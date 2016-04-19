defmodule Braintree.Testing.TestTransaction do
  @moduledoc """
  Create transasctions for testing purposes only.
  Transition to settled, settlement_confirmed, or settlement_declined
  """

  import Braintree.Util, only: [atomize: 1]

  alias Braintree.Transaction
  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error

  @doc """
  Use a `transaction_id` to transition to settled status
  Allows for testing of refunds

  ## Example

      {:ok, transaction} = TestTransaction.settle(transaction_id: "123")

      transaction.status # "settled"
  """
  @spec settle(String.t) :: {:ok, any} | {:error, Error.t}
  def settle(transaction_id) do
    case HTTP.put("transactions/#{transaction_id}/settle", %{}) do
      {:ok, %{"transaction" => transaction}} ->
        {:ok, Transaction.construct(transaction)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "Transaction ID is invalid."})}
    end
  end
  
  # TODO: settlement_confirmed
  # TODO: settlement_declined
  # TODO: verify testing environment
end
