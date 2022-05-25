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
      webhook_url: "https://www.myserver.com/webhook",
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
  alias KoraPay.Behaviour, as: Behaviour
  @behaviour Behaviour

  ### Entities ###
  @type card :: %{
          card_type: :mastercard | :visa | :verve,
          first_six: String.t(),
          last_four: String.t(),
          expiry: String.t()
        }

  @type transaction :: %{
          type: transaction_type(),
          amount: float(),
          fee: float(),
          narration: String.t(),
          currency: String.t(),
          created_at: DateTime.t(),
          status: status(),
          transaction_status: String.t(),
          reference: String.t(),
          callback_url: String.t(),
          meta: %{},
          customer: customer()
        }

  @type customer :: %{
          required(:email) => String.t(),
          optional(:name) => String.t(),
          optional(:phone) => String.t()
        }

  @type destination :: %{
          type: String.t(),
          amount: float(),
          currency: String.t(),
          narration: String.t(),
          bank_account: short_bank_account(),
          customer: customer()
        }

  @type disbursement :: %{
          amount: non_neg_integer(),
          fee: float(),
          currency: String.t(),
          status: status(),
          reference: String.t(),
          narration: String.t(),
          customer: customer()
        }

  @type charge_reference :: %{reference: String.t(), checkout_url: String.t()}

  # Auth
  @type auth_model :: :otp | :three_ds | :avs | :pin

  # Transaction types
  @type balance :: %{
          NGN: %{
            pending_balance: float(),
            available_balance: float()
          }
        }

  @type status :: :success | :pending | :processing | :expired | :failed

  @type transaction_type :: :collection | :disubursement

  @type channel :: :card | :bank_transfer

  ### Bank Account Types ###
  @type bank_account :: %{
          bank_name: String.t(),
          bank_code: String.t(),
          account_number: String.t(),
          account_name: String.t()
        }

  @type virtual_account :: %{
          account_reference: String.t(),
          unique_id: String.t(),
          account_status: String.t(),
          created_at: DateTime.t(),
          currency: String.t(),
          bank_account: bank_account(),
          customer: customer()
        }

  @type payer_bank_account :: %{
          account_number: String.t(),
          account_name: String.t(),
          bank_name: String.t()
        }

  @type short_bank_account :: %{
          bank: String.t(),
          account: String.t()
        }

  @type misc_bank_account :: %{
          code: String.t(),
          country: String.t(),
          name: String.t(),
          nibss_bank_code: String.t(),
          slug: String.t()
        }

  ### API Types ###
  @type charge_response :: %{
          amount: non_neg_integer(),
          amount_charged: non_neg_integer(),
          auth_model: auth_model(),
          currency: String.t(),
          fee: float(),
          vat: float(),
          response_message: String.t(),
          payment_reference: String.t(),
          status: status(),
          transaction_reference: String.t(),
          authorization: %{},
          card: card()
        }

  @type disbursement_status :: %{
          type: transaction_type(),
          transaction_status: String.t(),
          transaction_date: DateTime.t(),
          channel: channel(),
          disbursement: disbursement()
        }

  @type charge_status :: %{
          reference: String.t(),
          amount: non_neg_integer(),
          fee: float(),
          currency: String.t(),
          status: status(),
          description: String.t(),
          created_at: DateTime.t(),
          payer_bank_account: payer_bank_account(),
          card: card()
        }

  ### Helper Types
  @type charge_options :: %{
          optional(:redirect_url) => String.t(),
          optional(:channels) => [channel()],
          optional(:default_channel) => channel()
        }

  @type auth_options ::
          String.t()
          | %{
              state: String.t(),
              city: String.t(),
              country: String.t(),
              address: String.t(),
              zip_codes: String.t()
            }

  @type error :: {:error, %{reason: String.t(), details: %{}}}

  @doc """
    Create a generic payment.

    see: https://docs.korapay.com/#f192d2e8-aab2-4f5a-98ef-fa0ed7e2d853

  ## Examples
  ```
  iex(1)> KoraPay.create_charge(1000, "NGN", "test-xyz", %{email: "jycdmbhw@sharklasers.com"})
  {:ok, %{
      "checkout_url" => "https://test-checkout.korapay.com/test-txn/pay",
      "reference" => "test-txn" \# reference is automatically generated by library.
    }
  }
  ```
  ## Charge options
    A map of zero or more attributes.
    - `:redirect_url`: URL to redirect your customer when the transaction is complete.
    - `:default_channel`: channel that shows up when client modal is instantiated. E.g `"bank_transfer"`
    - `:channels`: Allowed payment channels for this transaction e.g `["card", "bank_transfer"]`
  """
  @impl Behaviour
  @spec create_charge(
          non_neg_integer(),
          String.t(),
          String.t(),
          customer(),
          charge_options()
        ) :: charge_response() | error()
  def create_charge(amount, currency, narration, customer, charge_options \\ %{}) do
    body_params =
      Map.merge(
        %{
          amount: to_string(amount),
          currency: currency,
          reference: generate_reference(),
          notification_url: Application.get_env(:kora_pay, :webhook_url),
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
  @impl Behaviour
  @spec charge_status(String.t()) :: charge_status() | error()
  def charge_status(reference), do: impl().query_charge(reference)

  @doc """
  Authorize a [charge](./KoraPay.html#charge_card/1) that is `:processing`.

  ## Examples
  ```
  iex(1)> KoraPay.authorize_charge("test-txn", :otp, "12345")
  iex(2)> KoraPay.authorize_charge("test-txn", :pin, "1234")
  iex(3)> KoraPay.authorize_charge("test-txn", :avs, %{state: "Lagos", city: "Lekki", ...})
  ```

  ## Options
    1. Required only if auth type is `:pin`
    2. Required only if auth type is `:otp`
    3. Required only if auth type is `:avs`
      - state
      - city
      - country
      - address
      - zip_codes
  """
  @impl Behaviour
  @spec authorize_charge(String.t(), auth_model(), auth_options()) ::
          charge_response() | error()
  def authorize_charge(txn_reference, auth_model, options) do
    auth =
      case auth_model do
        :avs -> %{avs: options}
        :otp -> %{otp: options}
        :pin -> %{pin: options}
      end

    body = %{
      transaction_reference: txn_reference,
      authorization: auth
    }

    impl().authorize_charge(body)
  end

  @doc """
  Create a charge on a card.

  ## Examples
  ```
  enc_data = "test_encrypted_base64_data"

  iex(1)> KoraPay.charge_card(enc_data)
  {:ok, %{
    "amount" => 200,
    "amount_charged" => 200,
    "auth_model" => "OTP",
    "currency" => "NGN",
    "fee": 2.6,
    "vat": 0.2,
    "response_message" => "Please enter the OTP sent to your mobile number 080****** and email te**@rave**.com",
    "payment_reference"=> "1To64uTVkRcRA",
    "status" => "processing",
    "transaction_reference"=> "KPY-CA-b5Mit73shYeQ",
    "card" => {
      "card_type": "mastercard",
      "first_six": "539983",
      "last_four": "8381",
      "expiry": "10/31"
    }
  }
  }}
  ```
  """
  @impl Behaviour
  @spec charge_card(String.t()) :: charge_response() | error()
  def charge_card(_charge_data) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.disburse()
      :world
  """
  @impl Behaviour
  @spec disburse(String.t(), destination()) :: disbursement() | error()
  def disburse(_reference, _destination) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.verify_disbursement()
      :world
  """
  @impl Behaviour
  @spec verify_disbursement(String.t()) :: disbursement_status() | error()
  def verify_disbursement(_reference) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  All transactions for a client.

  ## Examples
  ```
  iex(1)> KoraPay.transactions()
  {:ok,  [
      {
        "type" => "collection",
        "amount" => 1000,
        "fee" => 10,
        "narration" => "payment for a book",
        "currency" => "NGN",
        "created_at" => "2019-08-05T20:29:49.000Z",
        "status" => "success",
        "transaction_status" => "success",
        "reference" => "KPY-D-jLo7Zbk",
        "callback_url" => "https://example.com",
        "meta" => "{'product_name':'Becoming by Michelle Obama','product_description':''}",
        "customer" => {
          "name" => "Timi Adesoji",
          "email" => "johndoe@korapay.com",
        }
      }, ...]}
  ```
  """
  @impl Behaviour
  @spec transactions() :: [transaction()] | error()
  def transactions, do: impl().all_transactions()

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
  @impl Behaviour
  @spec resolve_bank_account(String.t(), String.t()) :: bank_account() | error()
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
  {:ok, [%{
    name: "First Bank of Nigeria",
    slug: "firstbank",
    code: "011",
    nibss_bank_code: "000016",
    country: "NG"
    }, ...]}
    ```
  """
  @impl Behaviour
  @spec list_banks() :: [misc_bank_account()] | error()
  def list_banks, do: impl().list_banks()

  @doc """
  Return account balances. (currently naira only)

  ## Examples
  ```
  iex(1)> KoraPay.balances()
  {:ok, %{"NGN" => %{"available_balance" => 946, "pending_balance" => 0}}}
  ```
  """
  @impl Behaviour
  @spec balances :: balance() | error()
  def balances, do: impl().get_balances()

  @doc """
  Create a virutal bank account.

  ## Examples
  ```
  iex(1)> KoraPay.create_virtual_bank_account()
  ```
  """
  @impl Behaviour
  @spec create_virtual_bank_account(
          String.t(),
          String.t(),
          boolean(),
          [String.t()],
          String.t(),
          customer()
        ) ::
          virtual_account() | error()
  def create_virtual_bank_account(_name, _reference, _permanent, _bvn, _bank_code, _customer) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @impl Behaviour
  @spec virtual_bank_account_details(String.t()) :: virtual_account() | error()
  def virtual_bank_account_details(ref), do: impl().virtual_bank_account_details(ref)

  defp generate_reference do
    # TODO: Generate UUIDs/ refs to be stored and track txns
    "test-txn"
  end

  defp impl, do: Application.get_env(:kora_pay, :api, KoraPay.Client)
end
