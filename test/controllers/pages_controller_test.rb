require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "still shipping page renders the anniversary story" do
    travel_to Time.find_zone("America/Los_Angeles").local(2026, 7, 18, 12) do
      get still_shipping_url

      assert_response :success
      assert_select "title", text: "Still shipping — one year of Sure"
      assert_select "[data-controller='milestone-story']"
      assert_select "h1", text: /The last image/
      assert_select "[role='img'][aria-label='359 of 365 days carried forward']"
      assert_select "a[href='https://github.com/we-promise/sure']"
      assert_select "a[href='https://github.com/maybe-finance/maybe/releases/tag/v0.6.0']"
    end
  end
end
