defmodule KoraPay.Behaviour do
  @moduledoc false

  @callback create_charge(%{
              required(:amount) => non_neg_integer(),
              required(:currency) => String.t(),
              required(:narration) => String.t(),
              required(:customer) => KoraPay.customer(),
              required(:reference) => String.t(),
              optional(:redirect_url) => String.t(),
              optional(:channels) => [KoraPay.channel()],
              optional(:default_channel) => KoraPay.channel()
            }) :: KoraPay.charge_response() | KoraPay.error()

  @callback charge_status(reference :: String.t()) :: KoraPay.charge_status() | KoraPay.error()

  @callback authorize_charge(%{
              transaction_reference: String.t(),
              authorization: %{
                required(KoraPay.auth_model()) => KoraPay.auth_options()
              }
            }) :: KoraPay.charge_response() | KoraPay.error()

  @callback charge_card(charge_data :: String.t()) :: KoraPay.charge_response() | KoraPay.error()

  @callback disburse(%{
              reference: String.t(),
              destination: %{
                type: String.t(),
                amount: non_neg_integer(),
                currency: String.t(),
                bank_account: KoraPay.bank_account(),
                customer: KoraPay.customer()
              }
            }) ::
              KoraPay.disbursement() | KoraPay.error()

  @callback verify_disbursement(reference :: String.t()) ::
              KoraPay.disbursement_status() | KoraPay.error()

  @callback transactions() :: [KoraPay.transaction()] | KoraPay.error()

  @callback resolve_bank_account(%{bank: String.t(), account: String.t()}) ::
              KoraPay.bank_account() | KoraPay.error()

  @callback list_banks() :: [KoraPay.misc_bank_account()] | KoraPay.error()

  @callback balances() :: KoraPay.balance() | KoraPay.error()

  @callback create_virtual_bank_account(%{
              account_name: String.t(),
              permanent: boolean(),
              bvn: [String.t()],
              bank_code: String.t(),
              customer: KoraPay.customer(),
              reference: String.t()
            }) :: KoraPay.virtual_account() | KoraPay.error()

  @callback virtual_bank_account_details(account_reference :: String.t()) ::
              KoraPay.virtual_account() | KoraPay.error()

  @callback virtual_bank_account_transactions(%{account_number: String.t()}) ::
              [KoraPay.virtual_bank_account_txn_response()] | KoraPay.error()
end
