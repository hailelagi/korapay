defmodule KoraPay do
  @moduledoc """
  todo: Documentation for `KoraPay`.
  """
  @behaviour KoraPay.Behaviour
  alias KoraPay.Behaviour, as: T

  @doc """
  Create a charge.

  ## Examples
    iex> KoraPay.create_charge()

  ## Options
  """

  @spec create_charge(
          non_neg_integer(),
          String.t(),
          String.t(),
          String.t(),
          String.t(),
          T.customer(),
          T.charge_options()
        ) :: T.charge_response() | T.error()
  def create_charge(
        _amount,
        _currency,
        _reference,
        _notification_url,
        _narration,
        _customer,
        _options
      ) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.charge_status()
      :world
  """
  @spec charge_status(reference :: String.t()) :: T.charge_status() | T.error()
  def charge_status(_reference) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.authorize_charge()
      :world

  ## Options
    - `:pin` :
    - `:otp` :
     `:avs` :
     `:state`:
     `:city`:
     `:country`:
     `:address`:
     `:zip_codes`:
  """
  @spec authorize_charge(String.t(), %{}, T.auth_options()) :: T.charge_response() | T.error()
  def authorize_charge(_txn_reference, _authorization, _options \\ %{}) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.charge_card()
      :world
  """
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
  @spec verify_disbursement(String.t()) :: T.disbursement_status() | T.error()
  def verify_disbursement(_reference) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.transactions()
  """
  @spec transactions :: [T.transaction()] | T.error()
  def transactions do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.resolve_bank_account()
  """
  @spec resolve_bank_account(String.t(), String.t()) :: T.bank_account() | T.error()
  def resolve_bank_account(_bank_code, _account_number) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.list_banks()
  """
  @spec list_banks() :: [T.misc_bank_account()] | T.error()
  def list_banks do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.balances()
      :world
  """

  @callback balances() :: T.balance() | T.error()
  def balances do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.charge_status()
  """

  @spec create_virtual_bank_account(
          String.t(),
          String.t(),
          boolean(),
          [String.t()],
          String.t(),
          T.customer()
        ) :: T.virtual_account() | T.error()
  def create_virtual_bank_account(_name, _reference, _permanent, _bvn, _bank_code, _customer) do
    {:error, %{reason: "not implemented", details: %{}}}
  end

  @doc """
  todo:

  ## Examples

      iex> KoraPay.virtual_bank_account_details()
  """
  @spec virtual_bank_account_details(String.t()) :: T.virtual_account() | T.error()
  def virtual_bank_account_details(_account_reference) do
    {:error, %{reason: "not implemented", details: %{}}}
  end
end
