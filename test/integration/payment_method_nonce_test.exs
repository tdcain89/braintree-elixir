defmodule Braintree.Integration.PaymentMethodTest do
  use ExUnit.Case, async: true

  alias Braintree.Customer
  alias Braintree.PaymentMethod
  alias Braintree.PaymentMethodNonce
  alias Braintree.Testing.CreditCardNumbers
  
  test "create/1 throws error message when provided invalid token" do
    {:error, error} = PaymentMethodNonce.create("invalid_token")
    
    assert error.message == "Token is invalid."
  end
  
  test "create/1 succeeds when provided valid token" do
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
    
    assert payment_method_nonce.type == "CreditCard"
  end
  
  defp master_card do
    CreditCardNumbers.master_cards() |> List.first
  end
end
