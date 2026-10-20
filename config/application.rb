require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MaybeMarketing
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.active_job.queue_adapter = :sidekiq

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.x.discord_url = ENV["DISCORD_URL"].presence || "https://discord.gg/36ZGBsxYEK"

    # Propshaft puts a content digest in every file name under public/assets, so
    # the file behind a URL there never changes and browsers can keep it for a
    # year. Missing files fall through to the app, and the rest of public/
    # (robots.txt, llms.txt, favicons) keeps the default headers.
    config.middleware.insert_before ActionDispatch::Static, Rack::Static,
      urls: [ "/assets" ], root: Rails.public_path, cascade: true,
      header_rules: [ [ :all, { "cache-control" => "public, max-age=31536000, immutable" } ] ]
  end
end
