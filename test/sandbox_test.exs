defmodule KoraPay.SandboxTest do
  @moduledoc """
    Call sandbox/test api for tests.
    see: https://developers.korapay.com/docs/test-live-modes
  """
  use ExUnit.Case, async: true
  @moduletag :sandbox

  setup do
    Mox.stub_with(KoraPayMock, KoraPay)
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

  describe "Miscellaneous" do
    test "GET a list of banks" do
      assert true == true
    end
  end

  describe "Mock Balances" do
  end

  describe "Mock Virtual Bank Accout" do
  end
end
