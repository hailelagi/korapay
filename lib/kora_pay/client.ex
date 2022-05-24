defmodule KoraPay.Client do
  @moduledoc """
    Create a client connection to the [korapay api](https://docs.korapay.com/),
    and query it. Some routes may require different authentication types, ensure
    the correct keys are supplied in `./config/config.exs` before starting the application.

    see: https://korahq.atlassian.net/wiki/spaces/AR/pages/733970455/Authentication

    You may wish to verify a client build by querying the api in an `iex` session:

    ```
      iex(1)> KoraPay.Client.get_balances()
      iex(2)> {:ok, %{"NGN" => %{"available_balance" => 0, "pending_balance" => 0}}}
    ```

    Do not consume the client directly, use the [public interface](./KoraPay.html) in your application:
    ```
    defmodule MyApp do
      def do_stuff do
        case KoraPay.list_banks() do
          {:ok, banks} <- IO.inspect(banks)
          {:error, error} <- IO.inspect(error)
        end
      end
    end
    ```
  """
  @version "v1"
  @namespace "merchant/api"

  @spec build_client(:public | :private) :: Tesla.Client.t()
  def build_client(auth_type) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.korapay.com/#{@namespace}/#{@version}"},
      {Tesla.Middleware.BearerAuth, token: Application.get_env(:kora_pay, auth_type)},
      {Tesla.Middleware.FormUrlencoded,
       encode: &Plug.Conn.Query.encode/1, decode: &Plug.Conn.Query.decode/1},
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
    |> Tesla.post("/transactions/disburse", body: opts)
    |> parse_response()
  end

  def verify_disbursed_txn(txn_ref) do
    build_client(:private)
    |> Tesla.get("/transactions/#{txn_ref}")
    |> parse_response()
  end

  def all_transactions do
    build_client(:private)
    |> Tesla.get("/transactions")
    |> parse_response()
  end

  def resolve_bank_account(opts) do
    build_client(:private)
    |> Tesla.post("/misc/banks/resolve", body: opts)
    |> parse_response()
  end

  def list_banks do
    build_client(:public)
    |> Tesla.get("/misc/banks")
    |> parse_response()
  end

  def get_balances do
    build_client(:private)
    |> Tesla.get("/balances")
    |> parse_response()
  end

  def create_virtual_bank_account(opts) do
    build_client(:private)
    |> Tesla.post("/virtual-bank-account", body: opts)
    |> parse_response()
  end

  def virtual_bank_account_details(ref) do
    build_client(:private)
    |> Tesla.get("/virtual-bank-account/#{ref}")
    |> parse_response()
  end

  defp parse_response(request) do
    case request do
      {:ok, %{status: 200, body: %{"status" => true} = body}} -> {:ok, body["data"]}
      response -> parse_error(response)
    end
  end

  defp parse_error(response) do
    case response do
    {:ok, %{status: 400, body: body}} -> {:error, %{reason: body["error"], details: body["message"]}}
    {:ok, %{status: 401, body: body}} -> {:error, %{reason: body["error"], details: body["message"]}}
    {:ok, %{status: 404, body: body}} ->  {:error, %{reason: body["error"], details: body["message"]}}
    {:ok, %{status: 403, body: body}} ->  {:error, %{reason: body["error"], details: body["message"]}}
    {:ok, %{status: 500, body: body}} -> {:error, %{reason: "Internal server error", details: body["message"]}}
    {:ok, %{status: status, body: body}} -> {:error, %{reason: "unexpected error - #{status}", details: body["message"]}}
    _ -> {:error, %{reason: "unexpected error", details: "unknown"}}
    end
  end
end
