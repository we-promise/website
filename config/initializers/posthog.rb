Rails.configuration.x.posthog = ActiveSupport::OrderedOptions.new
Rails.configuration.x.posthog.key = ENV['POSTHOG_KEY'].presence
Rails.configuration.x.posthog.host = ENV.fetch('POSTHOG_HOST', 'https://app.posthog.com')

if (api_key = Rails.configuration.x.posthog.key).present?
  PostHog.configure do |config|
    config.api_key = api_key
    config.host = Rails.configuration.x.posthog.host
  end
end
