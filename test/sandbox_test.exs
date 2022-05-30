defmodule KoraPay.SandboxTest do
  @moduledoc """
    Call sandbox/test api for tests.
    see: https://developers.korapay.com/docs/test-live-modes
  """
  use ExUnit.Case, async: true
  @moduletag :sandbox

  setup do
    Application.put_env(:kora_pay, :api, KoraPay.Client)
    :ok
  end

  # describe "Pay-ins" do
  #   test "POST to create a payment link" do
  #     assert {:ok, _} =
  #              KoraPay.create_charge(
  #                1000,
  #                "NGN",
  #                "test-xyz",
  #                %{email: "jycdmbhw@sharklasers.com"},
  #                "test-txn-init"
  #              )
  #   end

  #   test "GET the status of a card charge" do
  #     assert {:ok, _} = KoraPay.charge_status("test-xyz")
  #   end

  #   test "POST to authorize a charge on a card" do
  #     assert {:ok, _} = KoraPay.authorize_charge("test-txn", :otp, "12345")
  #   end

  #   test "POST to charge a card" do
  #     charge_data = Base.encode64("test-charge")

  #     assert {:ok, _} = KoraPay.charge_card(charge_data)
  #   end
  # end

  describe "Payouts" do
    # test "POST a disbursement to bank account" do
    #   bank_account = %{"bank" => "033", "account" => "0000000000"}
    #   customer = %{"name" => "John Doe", "email" => "johndoe@korapay.com"}

    #   assert {:ok, _} = KoraPay.disburse(1000, "NGN", bank_account, customer)
    # end

    # test "GET verification on a disbursement" do
    #   assert {:ok, _} = KoraPay.verify_disbursement("KPY_jLo7Zbk")
    # end
  end

  describe "Transactions" do
    test "GET all transactions" do
      assert {:ok, _} = KoraPay.transactions()
    end
  end

  describe "Verification" do
    test "POST to resolve a bank account" do
      assert {:ok, _} = KoraPay.resolve_bank_account("058", "0234247896")
    end
  end

  describe "Miscellaneous " do
    test "GET a list of banks" do
      assert {:ok, _} = KoraPay.list_banks()
    end
  end

  describe "Balances" do
    test "GET balances" do
      assert {:ok, _} = KoraPay.balances()
    end
  end

  describe "Virtual Bank Account" do
    test "POST to create a virtual bank account" do
      assert {:ok, _} =
               KoraPay.create_virtual_bank_account("Steph James", true, ["12345678901"], "035", %{
                 "name" => "Don Alpha"
               })
    end

    test "GET a virtual bank account's details" do
      assert {:ok, account} =
               KoraPay.create_virtual_bank_account("Steph James", true, ["12345678901"], "035", %{
                 "name" => "Don Alpha"
               })

      assert {:ok, _res} = KoraPay.virtual_bank_account_details(account["account_reference"])
    end

    test "does not GET an invalid account's details" do
      assert {:error, %{details: "Virtual bank account not found"}} =
               KoraPay.virtual_bank_account_details("xyz123abc456")
    end
  end
end
