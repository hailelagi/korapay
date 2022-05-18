defmodule KoraPay.Behaviour do
  ### Card Types ###
  @type charge_reference :: %{reference: String.t(), checkout_url: String.t()}

  @type auth_model :: :OTP | :THREE_DS | :AVS | :PIN

  @type auth_options :: %{
          optional(:pin) => String.t(),
          optional(:otp) => String.t(),
          optional(:avs) => %{},
          optional(:state) => String.t(),
          optional(:city) => String.t(),
          optional(:country) => String.t(),
          optional(:address) => String.t(),
          optional(:zip_codes) => String.t()
        }

  @type balance :: %{
          NGN: %{
            pending_balance: float(),
            available_balance: float()
          }
        }

  @type status :: :success | :pending | :processing | :expired | :failed
  @type transaction_type :: :collection | :disubursement
  @type channel :: :card | :bank_transfer

  @type card :: %{
          card_type: :mastercard | :visa | :verve,
          first_six: String.t(),
          last_four: String.t(),
          expiry: String.t()
        }

  @type customer :: %{
          required(:email) => String.t(),
          optional(:name) => String.t(),
          optional(:phone) => String.t()
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

  @type bank_account :: %{
          bank_name: String.t(),
          bank_code: String.t(),
          account_number: String.t(),
          account_name: String.t()
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
          name: String.t(),
          slug: String.t(),
          code: String.t(),
          country: String.t()
        }

  @type destination :: %{
          # bank_account
          type: String.t(),
          amount: float(),
          currency: String.t(),
          narration: String.t(),
          bank_account: short_bank_account(),
          customer: customer()
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

  @type charge_options :: %{
          redirect_url: String.t(),
          channels: [channel()],
          default_channel: channel()
        }

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

  @type disbursement :: %{
          amount: non_neg_integer(),
          fee: float(),
          currency: String.t(),
          status: status(),
          reference: String.t(),
          narration: String.t(),
          customer: customer()
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

  @type error :: {:error, %{reason: String.t(), details: %{}}}

  @callback create_charge(
              amount: non_neg_integer(),
              currency: String.t(),
              reference: String.t(),
              notification_url: String.t(),
              narration: String.t(),
              customer: customer(),
              options: charge_options()
            ) :: charge_response() | error()

  @callback charge_status(reference :: String.t()) :: charge_status() | error()

  @callback authorize_charge(
              txn_reference :: String.t(),
              authorization :: %{},
              options :: auth_options()
            ) :: nil

  @callback charge_card(charge_data :: String.t()) :: charge_response() | error()

  @callback disburse(reference :: String.t(), destination :: destination()) ::
              disbursement() | error()

  @callback verify_disbursement(reference :: String.t()) :: disbursement_status() | error()

  @callback transactions() :: [transaction()] | error()

  @callback resolve_bank_account(bank_code: String.t(), account_number: String.t()) ::
              bank_account() | error()

  @callback list_banks() :: [misc_bank_account()] | error()

  @callback balances() :: balance()

  @callback create_virtual_bank_account(
              name :: String.t(),
              reference :: String.t(),
              permanent :: boolean(),
              bvn :: [String.t()],
              bank_code :: String.t(),
              customer :: customer()
            ) :: virtual_account() | error()

  @callback virtual_bank_account_details(account_reference :: String.t()) ::
              virtual_account() | error()
end
