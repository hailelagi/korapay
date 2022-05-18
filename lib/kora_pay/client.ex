defmodule KoraPay.Client do
  use Tesla

  @version "v1"
  @namespace "merchant/api"

  plug(Tesla.Middleware.BaseUrl, "https://api.korapay.com/#{@namespace}/#{@version}/")
  plug(Tesla.Middleware.BearerAuth, "test token")
  plug(Tesla.Middleware.JSON)

  def initialize_charge(opts),
    do: Tesla.post("charges/initialize", body: opts) |> parse_response()

  def query_charge(ref), do: Tesla.get("charges/#{ref}") |> parse_response()

  def charge_card(opts), do: Tesla.post("charges/card", body: opts) |> parse_response()

  def authorize_charge(opts),
    do: Tesla.post("charges/card/authorize", body: opts) |> parse_response()

  def disburse_to_account(opts),
    do: Tesla.post("transactions/disburse", body: opts) |> parse_response()

  def verify_disbursed_txn(txn_ref), do: Tesla.get("transactions/#{txn_ref}") |> parse_response()

  def all_transactions, do: Tesla.get("transactions") |> parse_response()

  def resolve_bank_account(opts),
    do: Tesla.post("/misc/banks/resolve", body: opts) |> parse_response()

  def list_banks, do: Tesla.get("misc/banks") |> parse_response()
  def get_balances, do: Tesla.get("balances") |> parse_response()

  def create_virtual_bank_account(opts),
    do: Tesla.post("virtual-bank-account", opts) |> parse_response()

  def virtual_bank_account_details(ref),
    do: Tesla.get("virtual-bank-account/#{ref}") |> parse_response()
end

defp parse_response(request) do
  case request do
    {:ok, %{status: 200, body: %{status: true} = body}} -> {:ok, body["data"]}
    # {:ok, %{status: 200, body: body}} -> {:ok, body}
    response -> parse_error(response)
  end
end

def parse_error(response) do
  nil
end
