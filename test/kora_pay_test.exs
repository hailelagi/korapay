defmodule KoraPayTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  describe "Miscellaneous " do
    test "Get a list of banks" do
      expect(KoraPayMock, :list_banks, fn ->
        {:ok,
         [
           %{
             name: "First Bank of Nigeria",
             slug: "firstbank",
             code: "011",
             nibss_bank_code: "000016",
             country: "NG"
           }
         ]}
      end)

      assert {:ok, _} = KoraPay.list_banks()
    end
  end
end
