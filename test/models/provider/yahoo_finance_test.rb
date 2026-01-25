require "test_helper"

class Provider::YahooFinanceTest < ActiveSupport::TestCase
  include StockPriceProviderInterfaceTest

  setup do
    @subject = Provider::YahooFinance.new
  end

  test "exchange_rate returns rate for different currencies" do
    VCR.use_cassette "yahoo_finance/exchange_rate" do
      response = @subject.exchange_rate(from_currency: "USD", to_currency: "EUR")

      assert_respond_to response, :from_currency
      assert_respond_to response, :to_currency
      assert_respond_to response, :rate
      assert_respond_to response, :success?
    end
  end

  test "exchange_rate returns 1.0 for same currency" do
    response = @subject.exchange_rate(from_currency: "USD", to_currency: "USD")

    assert response.success?
    assert_equal 1.0, response.rate
    assert_equal "USD", response.from_currency
    assert_equal "USD", response.to_currency
  end

  test "exchange_rates returns historical rates" do
    VCR.use_cassette "yahoo_finance/exchange_rates" do
      response = @subject.exchange_rates(
        from_currency: "USD",
        to_currency: "EUR",
        start_date: Date.parse("2024-01-01"),
        end_date: Date.parse("2024-01-31")
      )

      assert_respond_to response, :from_currency
      assert_respond_to response, :to_currency
      assert_respond_to response, :rates
      assert_respond_to response, :success?
    end
  end

  test "exchange_rates returns daily rates for same currency" do
    response = @subject.exchange_rates(
      from_currency: "USD",
      to_currency: "USD",
      start_date: Date.parse("2024-01-01"),
      end_date: Date.parse("2024-01-03")
    )

    assert response.success?
    assert_equal 3, response.rates.length
    assert response.rates.all? { |r| r["rate"] == 1.0 }
  end
end
