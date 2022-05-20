defmodule KoraPay do
  @moduledoc """
  KoraPay REST HTTP client library.
  """
  @behaviour KoraPay.Behaviour

  alias KoraPay.Behaviour, as: T

  @doc """
  Create/intialize a charge. The first of several steps
  required to charge a card. After creation, call KoraPay.authorize(...)

  ## Examples
  ```
    iex> KoraPay.create_charge()
  ```
  ## Options

    A map of one or more attributes.
      - `redirect_url`:  URL to redirect your customer when the transaction is complete.
      - `default_channel`: channel that shows up when client modal is instantiated. E.g `"bank_transfer"`
      - `channels`: Allowed payment channels for this transaction. E.g `["card", "bank_transfer"]`
  """
  @impl T
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
        options \\ %{}
      ) do
    body_params = []

    case impl().charge_card(body_params) do
      {:ok, initiated_charge} -> initiated_charge
      _ -> {:error, %{reason: "not handled", details: %{}}}
    end
  end

  @doc """
  Find the status and details of a charge by providing the reference used/returned
  in the charge creation step.

  ## Examples

      iex> KoraPay.charge_status("kpy-ex-ref-1")
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
    - `:avs` :
    - `:state`:
    - `:city`:
    - `:country`:
    - `:address`:
    - `:zip_codes`:
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
  @impl T
  @spec list_banks() :: [T.misc_bank_account()] | T.error()
  def list_banks do
    case impl().list_banks() do
      {:ok, banks} ->{:ok, banks}
      _ -> {:error, %{reason: "not handled", details: %{}}}
    end

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

  defp impl, do: Application.get_env(:kora_pay, :api, KoraPay)
end
