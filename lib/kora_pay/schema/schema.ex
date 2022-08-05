defmodule KoraPay.Schema do

  @type virtual_bank_account_txn :: %{
          reference: String.t(),
          status: status(),
          amount: String.t(),
          fee: String.t(),
          currency: String.t(),
          description: String.t(),
          payer_bank_account: payer_bank_account()
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

  @type virtual_bank_account_txn_response :: %{
          total_amount_received: non_neg_integer(),
          account_number: String.t(),
          currency: String.t(),
          transactions: [virtual_bank_account_txn()],
          pagination: %{
            page: integer(),
            total: integer(),
            pageCount: integer(),
            totalPages: integer()
          }
        }

  def todo do
    nil
  end
end
