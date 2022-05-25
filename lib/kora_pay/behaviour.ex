defmodule KoraPay.Behaviour do
  @moduledoc false

  @callback create_charge(
              amount :: non_neg_integer(),
              currency :: String.t(),
              narration :: String.t(),
              customer :: KoraPay.customer(),
              options :: KoraPay.charge_options()
            ) :: KoraPay.charge_response() | KoraPay.error()

  @callback charge_status(reference :: String.t()) :: KoraPay.charge_status() | KoraPay.error()

  @callback authorize_charge(
              txn_reference :: String.t(),
              auth_model :: KoraPay.auth_model(),
              options :: KoraPay.auth_options()
            ) :: KoraPay.charge_response() | KoraPay.error()

  @callback charge_card(charge_data :: String.t()) :: KoraPay.charge_response() | KoraPay.error()

  @callback disburse(reference :: String.t(), destination :: KoraPay.destination()) ::
              KoraPay.disbursement() | KoraPay.error()

  @callback verify_disbursement(reference :: String.t()) ::
              KoraPay.disbursement_status() | KoraPay.error()

  @callback transactions() :: [KoraPay.transaction()] | KoraPay.error()

  @callback resolve_bank_account(bank_code :: String.t(), account_number :: String.t()) ::
              KoraPay.bank_account() | KoraPay.error()

  @callback list_banks() :: [KoraPay.misc_bank_account()] | KoraPay.error()

  @callback balances() :: KoraPay.balance() | KoraPay.error()

  @callback create_virtual_bank_account(
              name :: String.t(),
              reference :: String.t(),
              permanent :: boolean(),
              bvn :: [String.t()],
              bank_code :: String.t(),
              customer :: KoraPay.customer()
            ) :: KoraPay.virtual_account() | KoraPay.error()

  @callback virtual_bank_account_details(account_reference :: String.t()) ::
              KoraPay.virtual_account() | KoraPay.error()
end
