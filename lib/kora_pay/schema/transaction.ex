defmodule KoraPay.Schema.Transaction do
  @moduledoc false

  alias KoraPay.Schema.Customer

  @type txn_type :: :collection | :disubursement

  @type t :: %__MODULE__{
          reference: String.t(),
          status: Korapay.status(),
          type: txn_type(),
          amount: float(),
          fee: float(),
          narration: String.t(),
          currency: String.t(),
          created_at: DateTime.t(),
          transaction_status: String.t(),
          callback_url: String.t(),
          meta: %{},
          customer: Customer.t()
        }

  @fields ~w[reference status type amount fee narration currency created_at transaction_status callback_url meta customer]a

  defstruct @fields
end
