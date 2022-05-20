defmodule KoraPay.SandboxTest do
  @moduledoc """
    Call sandbox/test api for tests
  """
  use ExUnit.Case, async: true

  setup do
    :verify_on_exit!
    Mox.stub_with(KoraPayMock, KoraPay)
  end

  describe "Miscellaneous " do
    test "Get a list of banks" do
      assert KoraPay.list_banks() == true
    end
  end
end
