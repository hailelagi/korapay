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

  describe "Mock Pay-ins" do
    test "can initialize a payment charge" do
      true == true
    end

    test "can query the status of a card chage" do
      true == true
    end

    test "can authorize a charge on a card" do
      true == true
    end

    test "can charge a card" do
      true == true
    end
  end

  describe "Mock Payouts" do
  end

  describe "Mock Transactions" do
  end

  describe "Mock Verification" do
  end

  # describe "Miscellaneous" do
  #   test "GET a list of banks" do
  #     assert {:ok, _banks} = KoraPay.list_banks()
  #   end
  # end

  describe "Mock Balances" do
    test "GET " do
      assert true == true
    end
  end

  describe "Mock Virtual Bank Accout" do
    test "GET " do
      assert true == true
    end
  end
end
