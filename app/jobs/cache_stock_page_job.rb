class CacheStockPageJob < ApplicationJob
  queue_as :default

  def perform(stock)
    Rails.logger.info "Starting cache job for #{stock.symbol}:#{stock.mic_code}"
    Rails.logger.info "Stock object: #{stock.inspect}"

    # Cache the main page data
    cache_stock_data(stock)

    # Cache individual components data
    cache_chart_data(stock)
    cache_info_data(stock)
    cache_statistics_data(stock)
    cache_price_performance_data(stock)
    cache_similar_stocks_data(stock)

    Rails.logger.info "Completed cache job for #{stock.symbol}:#{stock.mic_code}"
  end

  private

  def yahoo_finance
    @yahoo_finance ||= Provider::YahooFinance.new
  end

  def cache_stock_data(stock)
    cache_key = "stock_data/#{stock.symbol}:#{stock.mic_code}"
    Rails.logger.info "Writing to cache key: #{cache_key}"
    Rails.cache.write(
      cache_key,
      {
        symbol: stock.symbol,
        name: stock.name,
        mic_code: stock.mic_code,
        country_code: stock.country_code,
        exchange: stock.exchange
      },
      expires_in: 24.hours
    )
  end

  def cache_chart_data(stock)
    Rails.logger.info "Caching chart data for #{stock.symbol}:#{stock.mic_code}"

    end_date = Date.today
    start_date = Date.today - 1.month

    response = yahoo_finance.stock_prices(
      ticker: stock.symbol,
      start_date: start_date,
      end_date: end_date,
      interval: "day",
      limit: 500
    )

    if response.success?
      valid_prices = response.prices.reject { |p| p["close"].nil? || p["open"].nil? }

      if valid_prices.any?
        latest_price = valid_prices.last["close"].to_f
        first_price = valid_prices.first["open"].to_f
        price_change = (latest_price - first_price).round(2)
        price_change_percentage = first_price.zero? ? 0 : ((price_change / first_price) * 100).round(2)
        currency = "USD"
      else
        latest_price = price_change = price_change_percentage = 0
        currency = "USD"
      end

      chart_data = {
        latest_price: latest_price,
        price_change: price_change,
        price_change_percentage: price_change_percentage,
        currency: currency,
        prices: valid_prices
      }

      cache_key = "stock_chart/v3/#{stock.symbol}:#{stock.mic_code}/1M"
      Rails.logger.info "Writing to cache key: #{cache_key}"
      Rails.cache.write(
        cache_key,
        chart_data,
        expires_in: 24.hours
      )
      Rails.logger.info "Successfully cached chart data for #{stock.symbol}:#{stock.mic_code}"
    else
      Rails.logger.error "Failed to fetch chart data for #{stock.symbol}:#{stock.mic_code}"
    end
  end

  def cache_info_data(stock)
    Rails.logger.info "Caching info data for #{stock.symbol}:#{stock.mic_code}"

    result = yahoo_finance.fetch_ticker_info(ticker: stock.symbol, mic_code: stock.mic_code)

    if result[:success]
      cache_key = "stock_info/v2/#{stock.symbol}:#{stock.mic_code}"
      Rails.logger.info "Writing to cache key: #{cache_key}"
      Rails.cache.write(
        cache_key,
        result[:data],
        expires_in: 24.hours
      )
      Rails.logger.info "Successfully cached info data for #{stock.symbol}:#{stock.mic_code}"
    else
      Rails.logger.error "Failed to fetch info data for #{stock.symbol}:#{stock.mic_code}"
    end
  end

  def cache_statistics_data(stock)
    Rails.logger.info "Caching statistics data for #{stock.symbol}:#{stock.mic_code}"

    result = yahoo_finance.fetch_ticker_info(ticker: stock.symbol, mic_code: stock.mic_code)

    if result[:success]
      market_data = result[:data] && result[:data]["market_data"] ? result[:data]["market_data"] : nil
      cache_key = "stock_statistics/v2/#{stock.symbol}:#{stock.mic_code}"
      Rails.logger.info "Writing to cache key: #{cache_key}"
      Rails.cache.write(
        cache_key,
        market_data,
        expires_in: 24.hours
      )
      Rails.logger.info "Successfully cached statistics data for #{stock.symbol}:#{stock.mic_code}"
    else
      Rails.logger.error "Failed to fetch statistics data for #{stock.symbol}:#{stock.mic_code}"
    end
  end

  def cache_price_performance_data(stock)
    Rails.logger.info "Caching price performance data for #{stock.symbol}:#{stock.mic_code}"

    result = yahoo_finance.fetch_real_time(ticker: stock.symbol, mic_code: stock.mic_code)

    if result[:success]
      performance_data = {
        low: result[:data]["low"],
        high: result[:data]["high"],
        current: result[:data]["fair_market_value"]
      }

      cache_key = "price_performance/v2/#{stock.symbol}:#{stock.mic_code}/24h"
      Rails.logger.info "Writing to cache key: #{cache_key}"
      Rails.cache.write(
        cache_key,
        performance_data,
        expires_in: 24.hours
      )
      Rails.logger.info "Successfully cached price performance data for #{stock.symbol}:#{stock.mic_code}"
    else
      Rails.logger.error "Failed to fetch price performance data for #{stock.symbol}:#{stock.mic_code}"
    end
  end

  def cache_similar_stocks_data(stock)
    Rails.logger.info "Caching similar stocks data for #{stock.symbol}:#{stock.mic_code}"

    # Yahoo Finance doesn't provide related stocks data, so we cache an empty array
    # Similar stocks feature will need to be implemented differently if needed
    similar_stocks = []

    cache_key = "similar_stocks/v2/#{stock.symbol}:#{stock.mic_code}"
    Rails.logger.info "Writing to cache key: #{cache_key}"
    Rails.logger.info "Data to be cached: #{similar_stocks.inspect}"
    Rails.cache.write(
      cache_key,
      similar_stocks,
      expires_in: 24.hours
    )
    Rails.logger.info "Successfully cached similar stocks data for #{stock.symbol}:#{stock.mic_code}"
  end
end
