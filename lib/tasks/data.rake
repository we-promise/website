namespace :data do
  desc "Load stock data (Note: bulk stock loading is no longer available after migration to Yahoo Finance)"
  task load_stocks: :environment do
    puts "=" * 60
    puts "NOTICE: Bulk stock loading is no longer available."
    puts ""
    puts "The Synth Finance API that provided this functionality has been"
    puts "replaced with Yahoo Finance, which does not offer a bulk ticker"
    puts "listing endpoint."
    puts ""
    puts "Alternative approaches:"
    puts "  1. Import stocks from a CSV file containing known tickers"
    puts "  2. Use an external data source for ticker lists"
    puts "  3. Add stocks manually as needed"
    puts "=" * 60
  end
end
