defmodule Braintree.Integration.PaymentMethodTest do
  use ExUnit.Case, async: true

  alias Braintree.Customer
  alias Braintree.PaymentMethod
  alias Braintree.PaymentMethodNonce
  alias Braintree.Testing.Nonces
  alias Braintree.Testing.CreditCardNumbers
  #alias Braintree.Testing.CreditCardNumbers.FailsSandboxVerification

  test "creates a payment method from an existing customer and fake nonce" do
    {:ok, customer} = Customer.create(%{
      first_name: "Bill",
      last_name: "Gates"
    })
    
    {:ok, payment_method} = PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: Nonces.transactable
      })
    
    assert payment_method.card_type == "Visa"
    assert payment_method.bin =~ ~r/^\w+$/
  end
  
  test "creates a payment method from a vaulted credit card nonce" do
    {:ok, customer} = Customer.create(
      first_name: "Rick",
      last_name: "Grimes",
      credit_card: %{
        number: master_card,
        expiration_date: "01/2016",
        cvv: "100"
      }
    )
    
    [card] = customer.credit_cards
    {:ok, payment_method_nonce} = PaymentMethodNonce.create(card.token)
    
    {:ok, payment_method} = PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: payment_method_nonce.nonce
      })
    
    assert payment_method.card_type == "MasterCard"
    assert payment_method.bin =~ card.bin
  end
  
  defp master_card do
    CreditCardNumbers.master_cards() |> List.first
  end
end
