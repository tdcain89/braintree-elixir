defmodule Braintree.PaymentMethodNonce do
  @moduledoc """
  Create a payment method nonce from an existing payment method token
  """
  @type t :: %__MODULE__{
               consumed:                 boolean,
               default:                  String.t,
               description:              String.t,
               details:                  Map.t,
               is_locked:                boolean,
               nonce:                    String.t,
               security_questions:       [],
               three_d_secure_info:      String.t,
               type:                     String.t
             }

  defstruct consumed:             false,
            default:              nil,
            description:          nil,
            details:              nil,
            is_locked:            false,
            nonce:                nil,
            security_questions:   nil,
            three_d_secure_info:  nil,
            type:                 nil

  import Braintree.Util, only: [atomize: 1]
  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error
  
  @doc """
  Create a payment method nonce from `token`

  ## Example

      {:ok, payment_method_nonce} = Braintree.PaymentMethodNonce.create(token)
      
      payment_method_nonce.nonce
  """
  @spec create(String.t) :: {:ok, t} | {:error, Error.t}
  def create(payment_method_token) do
    case HTTP.post("payment_methods/#{payment_method_token}/nonces", %{}) do
      {:ok, %{"payment_method_nonce" => payment_method_nonce}} ->
        {:ok, construct(payment_method_nonce)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
    end
  end
  
  def construct(map) do
    struct(__MODULE__, atomize(map))
  end
end
