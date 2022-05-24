defmodule KoraPay do
  @moduledoc """
  KoraPay client wrapper (https://docs.korapay.com/).

  ## Installation
  Set the the required environment variables for production.
  For development/sandbox data set `config/dev.exs`.

  see: https://developers.korapay.com/docs/api-keys

  ```
    config :kora_pay,
      public: "test_yourkey",
      private: "test_yourkey",

      # todo: decide if should load from config
      redirect_url: "test_url",
      webhook_url: "test_url",
  ```

  ## Usage
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
  @behaviour KoraPay.Behaviour

  alias KoraPay.Behaviour, as: T

  @doc """
    Create/intialize a charge. The first of several steps
    required to charge a card. After creation, call `KoraPay.authorize_charge(...)`
    to authorise.

    NOTE: References are automatically generated as a random string. Save the response.
    see: https://docs.korapay.com/#f192d2e8-aab2-4f5a-98ef-fa0ed7e2d853

  ## Examples
  ```
  iex(1)> KoraPay.create_charge(1000, "NGN", "https://webhook.site/8d321d8d-397f-4bab-bf4d-7e9ae3afbd50",
      "Fix Test Webhook", %{"name": "Jycdmbhw Name", email: "jycdmbhw@sharklasers.com"})
  {:ok, %{
    "checkout_url" => "https://test-checkout.korapay.com/test-txn/pay",
    "reference" => "test-txn"
    }}
  ```
  ## Charge options
    A map of zero or more attributes.
    - `:redirect_url`: URL to redirect your customer when the transaction is complete.
    - `:default_channel`: channel that shows up when client modal is instantiated. E.g `"bank_transfer"`
    - `:channels`: Allowed payment channels for this transaction e.g `["card", "bank_transfer"]`
  """
  @impl KoraPay.Behaviour
  @spec create_charge(
          non_neg_integer(),
          String.t(),
          String.t(),
          String.t(),
          T.customer(),
          T.charge_options()
        ) ::
          T.charge_response() | T.error()
  def create_charge(amount, currency, webhook_url, narration, customer, charge_options \\ %{}) do
    body_params =
      Map.merge(
        %{
          amount: to_string(amount),
          currency: currency,
          reference: generate_reference(),
          notification_url: webhook_url,
          narration: narration,
          customer: customer
        },
        charge_options
      )

    impl().initialize_charge(body_params)
  end

  @doc """
  Find the details of a charge by providing a reference.

  ## Examples
  ```
  iex(1)> KoraPay.charge_status("test-txn")
  {:ok, %{
          "amount" => "1000.00",
          "currency" => "NGN",
          "description" => "Fix Test Webhook",
          "fee" => nil,
          "reference" => "test-txn",
          "status" => "processing"
          }
    }
  ```
  """
  @impl KoraPay.Behaviour
  @spec charge_status(String.t()) :: T.charge_status() | T.error()
  def charge_status(reference), do: impl().query_charge(reference)

  @doc """
  Authorize a created charge that is "processing".

  ## Examples
  ```
  iex(1)> KoraPay.authorize_charge("test-txn", :otp, %{otp: "12345"})
  ```

  ## Options
    1. Required only if auth type is `:pin` e.g %`{pin: "1234'}`
    2. Required only if auth type is `:otp` e.g `%{otp: "12345"}`
    3. Required only if auth type is `:avs` e.g `%{state: "Lagos", city: "Lekki", ...}`
      - state
      - city
      - country
      - address
      - zip_codes
  """
  @impl KoraPay.Behaviour
  @spec authorize_charge(String.t(), T.auth_model(), T.auth_options()) ::
          T.charge_response() | T.error()
  def authorize_charge(txn_reference, auth_model, options) do
    body_params = if auth_model == :avs, do: %{avs: options}, else: options

    body = %{
      transaction_reference: txn_reference,
      authorization: body_params
    }

    impl().authorize_charge(body)
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.charge_card()
      :world
  """
  @impl KoraPay.Behaviour
  @spec charge_card(String.t()) :: T.charge_response() | T.error()
  def charge_card(_charge_data) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.disburse()
      :world
  """
  @impl KoraPay.Behaviour
  @spec disburse(String.t(), T.destination()) :: T.disbursement() | T.error()
  def disburse(_reference, _destination) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.verify_disbursement()
      :world
  """
  @impl KoraPay.Behaviour
  @spec verify_disbursement(String.t()) :: T.disbursement_status() | T.error()
  def verify_disbursement(_reference) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.transactions()
  """
  @impl KoraPay.Behaviour
  @spec transactions() :: [T.transaction()] | T.error()
  def transactions do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  Verify a bank account.

  ## Examples
  ```
  iex(1)> KoraPay.resolve_bank_account("058", "0234247896")
  {:ok, %{
   "account_name" => "OLAEGBE GBENGA EMMANUEL",
   "account_number" => "0234247896",
   "bank_code" => "058",
   "bank_name" => "GTBank Plc"
  }}
  ```
  """
  @impl KoraPay.Behaviour
  @spec resolve_bank_account(String.t(), String.t()) :: T.bank_account() | T.error()
  def resolve_bank_account(bank_code, account_number) do
    body_params = %{
      bank: bank_code,
      account: account_number
    }

    impl().resolve_bank_account(body_params)
  end

  @doc """
  All supported bank accounts.

  ## Example
  ```
  iex(1)> KoraPay.list_banks()
  [%{
    name: "First Bank of Nigeria",
    slug: "firstbank",
    code: "011",
    nibss_bank_code: "000016",
    country: "NG"
    }, ...]
    ```
  """
  @impl KoraPay.Behaviour
  @spec list_banks() :: [T.misc_bank_account()] | T.error()
  def list_banks, do: impl().list_banks()

  @doc """
  Return account balances. (currently naira only)

  ## Examples
  ```
  iex(1)> KoraPay.balances()
  %{"NGN" => %{"available_balance" => 946, "pending_balance" => 0}}
  ```
  """
  @impl KoraPay.Behaviour
  @spec balances :: T.balance() | T.error()
  def balances, do: impl().get_balances()

  @doc """
  todo:

  ## Examples

      iex> KoraPay.charge_status()
  """
  @impl KoraPay.Behaviour
  @spec create_virtual_bank_account(
          String.t(),
          String.t(),
          boolean(),
          [String.t()],
          String.t(),
          T.customer()
        ) ::
          T.virtual_account() | T.error()
  def create_virtual_bank_account(_name, _reference, _permanent, _bvn, _bank_code, _customer) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.virtual_bank_account_details()
  """
  @impl KoraPay.Behaviour
  @spec virtual_bank_account_details(String.t()) :: T.virtual_account() | T.error()
  def virtual_bank_account_details(_account_reference) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  defp generate_reference do
    # TODO: Generate UUIDs/ refs to be stored and track txns
    "test-txn"
  end

  defp impl, do: Application.get_env(:kora_pay, :api, KoraPay.Client)
end
