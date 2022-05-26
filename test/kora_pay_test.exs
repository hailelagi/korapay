defmodule KoraPayTest do
  use ExUnit.Case
  import Mox

  setup do
    verify!(KoraPayMock)
    :ok
  end

  describe "Mock Pay-ins" do
    test "can initialize a charge on a card" do
      expect(KoraPayMock, :create_charge, fn args ->
        {:ok,
         %{
           "checkout_url" => "https://test-checkout.korapay.com/test-txn/pay",
           "reference" => "x"
         }}
      end)

      assert {:ok, _} = KoraPay.create_charge(1000, "NGN", "test-xyz", %{email: "jycdmbhw@sharklasers.com"}, "test-ref")
    end
  end

  #   test "can query the status of a card chage" do
  #     true == false
  #   end

  #   test "can authorize a charge on a card" do
  #     true == false
  #   end

  #   test "can charge a card" do
  #     true == false
  #   end
  # end

  describe "Mock Payouts" do
  end

  describe "Mock Transactions" do
  end

  describe "Mock Verification" do
  end

  describe "Mock miscellaneous " do
    test "GET a list of banks" do
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

  # describe "Mock Balances" do
  # end

  # describe "Mock Virtual Bank Accout" do
  # end
end
