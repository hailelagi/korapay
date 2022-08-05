defmodule KoraPay.Schema.Card do
  @moduledoc false

  @type t :: %__MODULE__{
          card_type: :mastercard | :visa | :verve,
          first_six: String.t(),
          last_four: String.t(),
          expiry: String.t()
        }

  @fields ~w[card_type first_six last_four expiry]a
  defstruct @fields
end
