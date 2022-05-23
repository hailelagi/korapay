defmodule KoraPay.Client do
  @moduledoc """
    todo: document api auth types
  """

  use Tesla

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

  def initialize_charge(opts) do
    build_client(:private)
    |> Tesla.post("/charges/initialize", body: opts)
    |> parse_response()
  end

  def query_charge(ref) do
    build_client(:private)
    |> Tesla.get("/charges/#{ref}")
    |> parse_response()
  end

  def charge_card(opts) do
    build_client(:private)
    |> Tesla.post("/charges/card", body: opts)
    |> parse_response()
  end

  def authorize_charge(opts) do
    build_client(:private)
    |> Tesla.post("/charges/card/authorize", body: opts)
    |> parse_response()
  end

  def disburse_to_account(opts) do
    build_client(:private)
    |> Tesla.post("transactions/disburse", body: opts)
    |> parse_response()
  end

  def verify_disbursed_txn(txn_ref) do
    build_client(:private)
    |> Tesla.get("transactions/#{txn_ref}")
    |> parse_response()
  end

  def all_transactions do
    build_client(:private)
    |> Tesla.get("transactions")
    |> parse_response()
  end

  def resolve_bank_account(opts) do
    build_client(:private)
    |> Tesla.post("/misc/banks/resolve", body: opts)
    |> parse_response()
  end

  def list_banks do
    build_client(:public)
    |> Tesla.get("misc/banks")
    |> parse_response()
  end

  def get_balances do
    build_client(:public)
    |> Tesla.get("balances")
    |> parse_response()
  end

  def create_virtual_bank_account(opts) do
    build_client(:private)
    |> Tesla.post("virtual-bank-account", body: opts)
    |> parse_response()
  end

  def virtual_bank_account_details(ref) do
    build_client(:private)
    |> Tesla.get("virtual-bank-account/#{ref}")
    |> parse_response()
  end

  defp parse_response(request) do
    case request do
      # {:ok, %{status: 200, body: %{"status" => true, "message" => "Successful"} = body}} -> {:ok, body["data"]}
      # {:ok, %{status: 200, body: body}} -> {:ok, body}
      {:ok, response} -> parse_error(response)
    end
  end

  defp parse_error(response) do
    case response do
      # todo: catch generic network errors
      # {:ok, %{status: 401, body: body}} -> {:error, "reason"}
      # {:ok, %{status: 404, body: body}} ->  {:error, "reason"}
      # {:ok, %{status: 403, body: body}} ->  {:error, "reason"}
      # {:ok, %{status: 500, body: body}} -> {:error, "reason"}
      _ -> {:error, "unexpected error"}
    end
    nil
  end
end
