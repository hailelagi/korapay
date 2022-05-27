defmodule KoraPayTest do
  use ExUnit.Case
  import Mox

  setup do
    verify!(KoraPayMock)
    :ok
  end

  describe "Mock Pay-ins" do
    test "POST to create a payment link" do
      test_ref = "test-txn-init"

      expect(KoraPayMock, :create_charge, fn %{reference: test_ref} ->
        {:ok,
         %{
           "checkout_url" => "https://test-checkout.korapay.com/#{test_ref}/pay",
           "reference" => test_ref
         }}
      end)

      assert {:ok, _} =
               KoraPay.create_charge(
                 1000,
                 "NGN",
                 "test-xyz",
                 %{email: "jycdmbhw@sharklasers.com"},
                 test_ref
               )
    end

    test "GET the status of a card charge" do
      expect(KoraPayMock, :charge_status, fn ref ->
        {:ok,
         %{
           "amount" => "1000.00",
           "currency" => "NGN",
           "description" => "Fix Test Webhook",
           "fee" => nil,
           "reference" => ref,
           "status" => "processing"
         }}
      end)

      assert {:ok, _} = KoraPay.charge_status("test_fsjlfkl")
    end

    test "POST to authorize a charge on a card" do
      expect(KoraPayMock, :authorize_charge, fn _ ->
        {:ok,
         %{
           amount: 200,
           amount_charged: 200,
           auth_model: "OTP",
           currency: "NGN",
           fee: 2.6,
           vat: 0.2,
           response_message: "Card charged succesfully",
           payment_reference: "1To6auTVkRcRA",
           status: "processing",
           transaction_reference: "KPY-CA-DoTRqQptF5Qy",
           authorization: %{},
           card: %{
             card_type: "mastercard",
             first_six: "539983",
             last_four: "8381",
             expiry: "10/31"
           }
         }}
      end)

      assert {:ok, _} = KoraPay.authorize_charge("test-txn", :otp, "12345")
    end

    test "POST to charge a card" do
      charge_data = Base.encode64("test-charge")

      expect(KoraPayMock, :charge_card, fn _ ->
        {:ok,
         %{
           amount: 200,
           amount_charged: 200,
           auth_model: "OTP",
           currency: "NGN",
           fee: 2.6,
           vat: 0.2,
           response_message: "Card pin required",
           payment_reference: "1To6auTVkRcRA",
           status: "pending",
           transaction_reference: "KPY-CA-DoTRqQptF5Qy",
           card: %{
             card_type: "mastercard",
             first_six: "539983",
             last_four: "8381",
             expiry: "10/31"
           }
         }}
      end)

      assert {:ok, _} = KoraPay.charge_card(charge_data)
    end
  end

  describe "Mock Payouts" do
    test "POST a disbursement to bank account" do
      bank_account = %{"bank" => "033", "account" => "0000000000"}
      customer = %{"name" => "John Doe", "email" => "johndoe@korapay.com"}

      expect(KoraPayMock, :disburse, fn _ ->
        {:ok,
         %{
           "amount" => "100.00",
           "fee" => "2.50",
           "currency" => "NGN",
           "status" => "processing",
           "reference" => "KPY-D-t74azVrw9oPLtv9",
           "narration" => "Test Transfer Payment",
           "customer" => %{
             "name" => "John Doe",
             "email" => "johndoe@korapay.com"
           }
         }}
      end)

      assert {:ok, _} = KoraPay.disburse(1000, "NGN", bank_account, customer)
    end

    test "GET verification on a disbursement" do
      expect(KoraPayMock, :verify_disbursement, fn _ ->
        {:ok,
         %{
           "amount" => 1000,
           "fee" => 10,
           "narration" => "payout to customer",
           "currency" => "NGN",
           "created_at" => "2019-08-05T20:29:49.000Z",
           "status" => "success",
           "reference" => "KPY_jLo7Zbk",
           "callback_url" => "https://example.com",
           "trace_id" => "000000000000000111111111111111",
           "message" => "Payout successful",
           "customer" => %{
             "name" => "John Doe",
             "email" => "johndoe@korapay.com"
           }
         }}
      end)

      assert {:ok, _} = KoraPay.verify_disbursement("KPY_jLo7Zbk")
    end
  end

  describe "Mock Transactions" do
    test "GET all transactions" do
      expect(KoraPayMock, :transactions, fn ->
        {:ok,
         [
           %{
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
             "customer" => %{
               "name" => "Timi Adesoji",
               "email" => "johndoe@korapay.com"
             }
           }
         ]}
      end)

      assert {:ok, _} = KoraPay.transactions()
    end
  end

  describe "Mock Verification" do
    test "POST to resolve a bank account" do
      expect(KoraPayMock, :resolve_bank_account, fn _ ->
        {:ok,
         %{
           "account_name" => "OLAEGBE GBENGA EMMANUEL",
           "account_number" => "0234247896",
           "bank_code" => "058",
           "bank_name" => "GTBank Plc"
         }}
      end)

      assert {:ok, _} = KoraPay.resolve_bank_account("058", "0234247896")
    end
  end

  describe "Mock miscellaneous " do
    test "GET a list of banks" do
      expect(KoraPayMock, :list_banks, fn ->
        {:ok,
         [
           %{
             name: "First Bank of Nigeria",
             slug: "firstbank",
             code: "011",
             nibss_bank_code: "000016",
             country: "NG"
           }
         ]}
      end)

      assert {:ok, _} = KoraPay.list_banks()
    end
  end

  describe "Mock Balances" do
    test "GET balances" do
      expect(KoraPayMock, :balances, fn ->
        {:ok, %{"NGN" => %{"available_balance" => 946, "pending_balance" => 0}}}
      end)

      assert {:ok, _} = KoraPay.balances()
    end
  end

  describe "Mock Virtual Bank Account" do
    test "POST to create a virtual bank account" do
      expect(KoraPayMock, :create_virtual_bank_account, fn _ ->
        {:ok,
         %{
           "account_name" => "Steph James",
           "account_number" => "2341240011",
           "bank_code" => "035",
           "bank_name" => "Wema Bank",
           "account_reference" => "xyz123abc456",
           "unique_id" => "KPY-VA-ab12cd34ef56",
           "account_status" => "active",
           "created_at" => "2021-09-15T11:05:51.428Z",
           "currency" => "NGN",
           "customer" => %{
             "name" => "Don Alpha"
           }
         }}
      end)

      assert {:ok, _} =
               KoraPay.create_virtual_bank_account("Steph James", true, ["12345678901"], "035", %{
                 "name" => "Don Alpha"
               })
    end

    test "GET a virtual bank account's details" do
      expect(KoraPayMock, :virtual_bank_account_details, fn _ ->
        {:ok,
         %{
           "account_name" => "Steph James",
           "account_number" => "2341240011",
           "bank_code" => "035",
           "bank_name" => "Wema Bank",
           "account_reference" => "xyz123abc456",
           "unique_id" => "KPY-VA-ab12cd34ef56",
           "account_status" => "active",
           "created_at" => "2021-09-15T11:05:51.428Z",
           "currency" => "NGN",
           "customer" => %{
             "name" => "Don Alpha"
           }
         }}
      end)

      assert {:ok, res} = KoraPay.virtual_bank_account_details("test-ref")
    end
  end
end
