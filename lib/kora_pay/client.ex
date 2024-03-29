defmodule KoraPay.Client do
  @moduledoc """
    Create a connection to the [korapay api](https://docs.korapay.com/),
    and query it. Some routes may require different authentication types, ensure
    the correct keys are supplied in `./config` before starting the application.

    see: https://korahq.atlassian.net/wiki/spaces/AR/pages/733970455/Authentication

    You may wish to verify a client build by querying the api in an `iex` session:

    ```
      iex(1)> KoraPay.Client.get_balances()
      iex(2)> {:ok, %{"NGN" => %{"available_balance" => 0, "pending_balance" => 0}}}
    ```
  """
  alias KoraPay.Behaviour
  alias KoraPay.ParseError

  @behaviour Behaviour

  @version "v1"
  @namespace "merchant/api"


  @spec build_client(:public | :private) :: Tesla.Client.t()
  def build_client(auth_type) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.korapay.com/#{@namespace}/#{@version}"},
      {Tesla.Middleware.BearerAuth, token: Application.get_env(:kora_pay, auth_type)},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  @impl Behaviour
  def create_charge(opts) do
    build_client(:private)
    |> Tesla.post("/charges/initialize", opts)
    |> parse_response()
  end

  @impl Behaviour
  def charge_status(ref) do
    build_client(:private)
    |> Tesla.get("/charges/#{ref}")
    |> parse_response()
  end

  @impl Behaviour
  def charge_card(opts) do
    build_client(:private)
    |> Tesla.post("/charges/card", opts)
    |> parse_response()
  end

  @impl Behaviour
  def authorize_charge(opts) do
    build_client(:private)
    |> Tesla.post("/charges/card/authorize", opts)
    |> parse_response()
  end

  @impl Behaviour
  def disburse(opts) do
    build_client(:private)
    |> Tesla.post("/transactions/disburse", opts)
    |> parse_response()
  end

  @impl Behaviour
  def verify_disbursement(txn_ref) do
    build_client(:private)
    |> Tesla.get("/transactions/#{txn_ref}")
    |> parse_response()
  end

  @impl Behaviour
  def transactions do
    build_client(:private)
    |> Tesla.get("/transactions")
    |> parse_response()
  end

  @impl Behaviour
  def resolve_bank_account(opts) do
    build_client(:public)
    |> Tesla.post("/misc/banks/resolve", opts)
    |> parse_response()
  end

  @impl Behaviour
  def list_banks do
    build_client(:public)
    |> Tesla.get("/misc/banks")
    |> parse_response()
  end

  @impl Behaviour
  def balances do
    build_client(:private)
    |> Tesla.get("/balances")
    |> parse_response()
  end

  @impl Behaviour
  def create_virtual_bank_account(opts) do
    build_client(:private)
    |> Tesla.post("/virtual-bank-account", opts)
    |> parse_response()
  end

  @impl Behaviour
  def virtual_bank_account_details(ref) do
    build_client(:private)
    |> Tesla.get("/virtual-bank-account/#{ref}")
    |> parse_response()
  end

  @impl Behaviour

  def virtual_bank_account_transactions(opts) do
    build_client(:private)
    |> Tesla.get("/virtual-bank-account/transactions", body: opts)
    |> parse_response()
  end

  defp parse_response(request) do
    case request do
      {:ok, %{status: 200, body: %{"status" => true} = body}} ->
        {:ok, body["data"]}

      response -> ParseError.call(response)
    end
  end
end
