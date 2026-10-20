require "test_helper"

class AssetCacheHeadersTest < ActionDispatch::IntegrationTest
  setup do
    @asset = Rails.public_path.join("assets", "cache-test-#{SecureRandom.hex(4)}.txt")
    @asset.dirname.mkpath
    @asset.write("test")
  end

  teardown do
    @asset.delete
  end

  test "only digested assets are cached for a year" do
    get "/assets/#{@asset.basename}"
    assert_response :ok
    assert_equal "public, max-age=31536000, immutable", response.headers["cache-control"]

    get "/assets/missing-0123abcd.png"
    assert_response :not_found
    assert_not_includes response.headers["cache-control"].to_s, "immutable"

    get "/robots.txt"
    assert_response :ok
    assert_not_includes response.headers["cache-control"].to_s, "immutable"
  end
end
