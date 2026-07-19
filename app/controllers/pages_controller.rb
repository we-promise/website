# PagesController handles various static and dynamic pages in the application.
# It includes methods for the home page, terms of service, privacy policy, and sitemap.
# The controller also fetches and caches the stargazers count from GitHub for the Sure repository.

require "net/http"
require "json"

class PagesController < ApplicationController
  # GET /
  # Renders the home page and displays the number of GitHub stars for the Sure repository.
  # The star count is cached for 24 hours to reduce API calls.
  #
  # @return [Integer, nil] The number of GitHub stars or nil if fetching fails
  def index
    @stars = Rails.cache.fetch("sure_stargazers_count", expires_in: 72.hours) do
      fetch_stars_count
    end
  end

  # GET /tos
  # Renders the Terms of Service page.
  def tos
  end

  # GET /privacy
  # Renders the Privacy Policy page.
  def privacy
  end

  # GET /about
  # Renders the About Us page.
  def about
    @stars = Rails.cache.fetch("sure_stargazers_count", expires_in: 72.hours) do
      fetch_stars_count
    end
  end

  # GET /still-shipping
  # Renders the interactive story marking one year since Maybe's final image.
  def still_shipping
    milestone_start = Date.new(2025, 7, 24)
    milestone_date = Date.new(2026, 7, 24)
    story_date = Time.current.in_time_zone("America/Los_Angeles").to_date

    @days_carried = (story_date - milestone_start).to_i.clamp(0, 365)
    @days_until_anniversary = [ (milestone_date - story_date).to_i, 0 ].max
    @anniversary_reached = story_date >= milestone_date
    @anniversary_today = story_date == milestone_date
    @anniversary_progress = (@days_carried.fdiv(365) * 100).round(2)

    render layout: "still_shipping"
  end


  # GET /sitemap.xml
  # Generates a sitemap index file with links to multiple sitemaps.
  #
  # @return [XML] Sitemap index file
  def sitemap_index
    @terms = Term.all
    @articles = Article.all.order(publish_at: :desc).where("publish_at <= ?", Time.now)
    @faqs = Faq.all.order(:question)
    @tools = Tool.all
    @authors = Author.all

    @exchange_rate_currencies = Tool::Presenter::ExchangeRateCalculator.new.currency_options
    respond_to do |format|
      format.xml
    end
  end

  private

  # Fetches the current number of stars for the Sure GitHub repository.
  # Uses the ungh.cc API to retrieve the star count.
  #
  # @return [Integer, nil] The number of stars or nil if there's an error during the API call
  # @example
  #   fetch_stars_count # => 1234
  def fetch_stars_count
    url = URI("https://ungh.cc/repos/we-promise/sure")
    response = Net::HTTP.start(url.host, url.port, use_ssl: true, open_timeout: 2, read_timeout: 2) do |http|
      http.get(url.request_uri)
    end
    json = JSON.parse(response.body)
    json.dig("repo", "stars")
  rescue StandardError => e
    Rails.logger.error "Failed to fetch stars count: #{e.message}"
    nil
  end
end
