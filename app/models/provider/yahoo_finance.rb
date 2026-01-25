class Provider::YahooFinance
  def stock_price(ticker:, date:)
    response = fetch_stock_prices(ticker: ticker, start_date: date, end_date: date)

    if response.success? && (prices = parse_prices(response)).any?
      price = prices.first
      StockPriceResponse.new \
        ticker: ticker,
        close: price[:close],
        date: price[:date],
        success?: true,
        raw_response: response
    else
      StockPriceResponse.new ticker: ticker, success?: false, raw_response: response
    end
  end

  def stock_prices(ticker:, start_date:, end_date:, interval: "day", limit: 100)
    response = fetch_stock_prices(ticker: ticker, start_date: start_date, end_date: end_date, interval: interval)

    if response.success?
      prices = parse_prices(response).take(limit)
      StockPricesResponse.new \
        ticker: ticker,
        prices: prices.map { |p| { "date" => p[:date], "open" => p[:open], "close" => p[:close], "high" => p[:high], "low" => p[:low], "volume" => p[:volume] } },
        start_date: start_date.to_s,
        end_date: end_date.to_s,
        success?: true,
        raw_response: response
    else
      StockPricesResponse.new \
        ticker: ticker,
        start_date: start_date.to_s,
        end_date: end_date.to_s,
        success?: false,
        raw_response: response
    end
  end

  def exchange_rate(from_currency:, to_currency:)
    return same_currency_rate(from_currency) if from_currency == to_currency

    symbol = "#{from_currency}#{to_currency}=X"
    response = fetch_chart(symbol: symbol, range: "1d", interval: "1d")

    if response.success?
      data = JSON.parse(response.body)
      result = data.dig("chart", "result")&.first
      price = result&.dig("meta", "regularMarketPrice")

      if price
        ExchangeRateResponse.new(
          from_currency: from_currency,
          to_currency: to_currency,
          rate: price,
          date: Date.today.to_s,
          time: Time.now.utc.strftime("%H:%M:%S"),
          success?: true,
          raw_response: response
        )
      else
        ExchangeRateResponse.new(
          from_currency: from_currency,
          to_currency: to_currency,
          success?: false,
          raw_response: response
        )
      end
    else
      ExchangeRateResponse.new(
        from_currency: from_currency,
        to_currency: to_currency,
        success?: false,
        raw_response: response
      )
    end
  end

  def exchange_rates(from_currency:, to_currency:, start_date:, end_date:)
    return same_currency_rates(from_currency, to_currency, start_date, end_date) if from_currency == to_currency

    symbol = "#{from_currency}#{to_currency}=X"
    period1 = start_date.to_time.to_i
    period2 = (end_date + 1.day).to_time.to_i

    response = fetch_chart_historical(symbol: symbol, period1: period1, period2: period2, interval: "1d")

    if response.success?
      data = JSON.parse(response.body)
      result = data.dig("chart", "result")&.first

      if result
        timestamps = result["timestamp"] || []
        closes = result.dig("indicators", "quote", 0, "close") || []

        rates = timestamps.zip(closes).filter_map do |timestamp, close|
          next unless close
          {
            "date" => Time.at(timestamp).utc.to_date.to_s,
            "rate" => close
          }
        end

        ExchangeRatesResponse.new(
          from_currency: from_currency,
          to_currency: to_currency,
          rates: rates,
          success?: true,
          raw_response: response
        )
      else
        ExchangeRatesResponse.new(
          from_currency: from_currency,
          to_currency: to_currency,
          success?: false,
          raw_response: response
        )
      end
    else
      ExchangeRatesResponse.new(
        from_currency: from_currency,
        to_currency: to_currency,
        success?: false,
        raw_response: response
      )
    end
  end

  # Additional methods for stock data
  def fetch_ticker_info(ticker:, mic_code: nil)
    response = fetch_chart(symbol: ticker, range: "1d", interval: "1d")

    if response.success?
      data = JSON.parse(response.body)
      result = data.dig("chart", "result")&.first
      meta = result&.dig("meta") || {}

      {
        success: true,
        data: {
          "ticker" => ticker,
          "name" => meta["shortName"] || meta["longName"],
          "currency" => meta["currency"],
          "exchange" => meta["exchangeName"],
          "market_data" => {
            "open_today" => meta["regularMarketOpen"],
            "price_change" => meta["regularMarketPrice"].to_f - meta["previousClose"].to_f,
            "percent_change" => ((meta["regularMarketPrice"].to_f - meta["previousClose"].to_f) / meta["previousClose"].to_f * 100).round(2)
          }
        },
        raw_response: response
      }
    else
      { success: false, raw_response: response }
    end
  end

  def fetch_real_time(ticker:, mic_code: nil)
    response = fetch_chart(symbol: ticker, range: "1d", interval: "1m")

    if response.success?
      data = JSON.parse(response.body)
      result = data.dig("chart", "result")&.first
      meta = result&.dig("meta") || {}
      quotes = result.dig("indicators", "quote", 0) || {}

      highs = (quotes["high"] || []).compact
      lows = (quotes["low"] || []).compact

      {
        success: true,
        data: {
          "fair_market_value" => meta["regularMarketPrice"],
          "high" => highs.max,
          "low" => lows.min
        },
        raw_response: response
      }
    else
      { success: false, raw_response: response }
    end
  end

  private
    BASE_URL = "https://query1.finance.yahoo.com"

    StockPriceResponse = Struct.new :ticker, :date, :close, :success?, :raw_response, keyword_init: true
    StockPricesResponse = Struct.new :ticker, :start_date, :end_date, :prices, :success?, :raw_response, keyword_init: true
    ExchangeRateResponse = Struct.new(
      :from_currency,
      :to_currency,
      :rate,
      :date,
      :time,
      :success?,
      :raw_response,
      keyword_init: true
    )
    ExchangeRatesResponse = Struct.new(
      :from_currency,
      :to_currency,
      :rates,
      :success?,
      :raw_response,
      keyword_init: true
    )

    def fetch_stock_prices(ticker:, start_date:, end_date:, interval: "day")
      yahoo_interval = interval_to_yahoo(interval)
      period1 = start_date.to_time.to_i
      period2 = (end_date + 1.day).to_time.to_i

      fetch_chart_historical(symbol: ticker, period1: period1, period2: period2, interval: yahoo_interval)
    end

    def fetch_chart(symbol:, range:, interval:)
      Faraday.get("#{BASE_URL}/v8/finance/chart/#{CGI.escape(symbol)}") do |req|
        req.params["range"] = range
        req.params["interval"] = interval
        req.headers["User-Agent"] = "Mozilla/5.0"
      end
    end

    def fetch_chart_historical(symbol:, period1:, period2:, interval:)
      Faraday.get("#{BASE_URL}/v8/finance/chart/#{CGI.escape(symbol)}") do |req|
        req.params["period1"] = period1
        req.params["period2"] = period2
        req.params["interval"] = interval
        req.headers["User-Agent"] = "Mozilla/5.0"
      end
    end

    def parse_prices(response)
      return [] unless response.success?

      data = JSON.parse(response.body)
      result = data.dig("chart", "result")&.first
      return [] unless result

      timestamps = result["timestamp"] || []
      quotes = result.dig("indicators", "quote", 0) || {}

      timestamps.each_with_index.filter_map do |timestamp, i|
        close = quotes.dig("close", i)
        next unless close

        {
          date: Time.at(timestamp).utc.to_date.to_s,
          open: quotes.dig("open", i),
          close: close,
          high: quotes.dig("high", i),
          low: quotes.dig("low", i),
          volume: quotes.dig("volume", i)
        }
      end
    end

    def interval_to_yahoo(interval)
      case interval.to_s
      when "day" then "1d"
      when "week" then "1wk"
      when "month" then "1mo"
      else "1d"
      end
    end

    def same_currency_rate(currency)
      ExchangeRateResponse.new(
        from_currency: currency,
        to_currency: currency,
        rate: 1.0,
        date: Date.today.to_s,
        time: Time.now.utc.strftime("%H:%M:%S"),
        success?: true,
        raw_response: nil
      )
    end

    def same_currency_rates(from_currency, to_currency, start_date, end_date)
      rates = (start_date..end_date).map do |date|
        { "date" => date.to_s, "rate" => 1.0 }
      end

      ExchangeRatesResponse.new(
        from_currency: from_currency,
        to_currency: to_currency,
        rates: rates,
        success?: true,
        raw_response: nil
      )
    end
end
