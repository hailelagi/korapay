defmodule KoraPay.Schema.Customer do
  @moduledoc false

  @type t :: %{
          required(:email) => String.t(),
          optional(:name) => String.t(),
          optional(:phone) => String.t()
        }

  @enforce_keys [:email]

  defstruct email: nil
end
