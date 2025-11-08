if (api_key = ENV['POSTHOG_KEY']).present?
  PostHog.configure do |config|
    config.api_key = api_key
    config.host = ENV.fetch('POSTHOG_HOST', 'https://app.posthog.com')
  end
end
