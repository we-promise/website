require "test_helper"

class FeaturesControllerTest < ActionDispatch::IntegrationTest
  # Every tab used to fall back to Spending: the list of valid categories held
  # page names instead of tab names.
  test "each assistant tab shows its own cards" do
    {
      "spending" => "Spending habits vs last month",
      "investment" => "What's in my portfolio",
      "analysis" => "Debt paid off",
      "planning" => "Budget check-in"
    }.each do |category, card_title|
      get assistant_category_url(category: category)

      assert_response :success
      assert_select "h3", text: card_title
    end
  end

  test "an unknown assistant tab falls back to spending" do
    get assistant_category_url(category: "forecasts")

    assert_response :success
    assert_select "h3", text: "Spending habits vs last month"
  end
end
