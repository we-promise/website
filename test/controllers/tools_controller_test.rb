require "test_helper"

class ToolsControllerTest < ActionDispatch::IntegrationTest
  LIVE_TOOLS = %w[
    401k-retirement-calculator compound-interest-calculator early-mortgage-payoff-calculator financial-freedom-calculator
    home-affordability-calculator inflation-calculator loan-calculator roi-calculator
  ]

  setup do
    MortgageRate::Cache.any_instance.stubs(:rate_30).returns(nil)
    MortgageRate::Cache.any_instance.stubs(:rate_15).returns(nil)
  end

  test "index" do
    get tools_url
    assert_response :success
  end

  test "show" do
    get tool_url("roi-calculator")
    assert_response :success
  end

  test "show with evil intentions" do
    get tool_url("inaccessible-tool")
    assert_response :not_found
  end

  test "calculating with the untouched form reproduces the first result" do
    travel_to Date.new(2026, 10, 20) do
      LIVE_TOOLS.each do |slug|
        get tool_url(slug)
        form = css_select("aside form").first
        results = "turbo-frame##{form["data-turbo-frame"]}"
        first_result = css_select(results).to_s
        prefilled = form.css("input[name]").to_h { |input| [ input["name"], input["value"] ] }

        get tool_url(slug), params: prefilled

        assert_equal first_result, css_select(results).to_s, "#{slug} recalculated with different inputs"
      end
    end
  end

  test "a tool ignores params that belong to other tools" do
    presenters = LIVE_TOOLS.index_with { |slug| Tool.presenter_class_for(slug) }
    every_param = (presenters.values + [ Tool::Presenter::ExchangeRateCalculator ]).flat_map(&:attribute_names).uniq

    presenters.each do |slug, presenter|
      get tool_url(slug), params: (every_param - presenter.attribute_names).index_with("1")
      assert_response :success, slug
    end
  end

  test "currency and symbol paths no longer route to tools" do
    get "/tools/loan-calculator/USD/EUR"
    assert_response :not_found

    get "/tools/roi-calculator/AAPL"
    assert_response :not_found
  end

  test "inflation calculator reads the rate its form sends" do
    get tool_url("inflation-calculator", inflation_percentage: 10)
    assert_select "p", text: /at 10.0% inflation annually/

    get tool_url("inflation-calculator", inflation_rate: 10)
    assert_response :success
  end

  test "home affordability shows a default rate unless FRED has one" do
    get tool_url("home-affordability-calculator")
    assert_select "input[name=loan_interest_rate][value='6.5']"
    assert_select "[data-mortgage-rate-select-rate30-value], [data-mortgage-rate-select-rate15-value]", count: 0

    MortgageRate::Cache.any_instance.stubs(:rate_30).returns("6.27")
    MortgageRate::Cache.any_instance.stubs(:rate_15).returns("5.41")
    get tool_url("home-affordability-calculator")
    assert_select "[data-mortgage-rate-select-rate30-value='6.27'][data-mortgage-rate-select-rate15-value='5.41']"
  end

  test "roi calculator explains a missing annualized roi" do
    get tool_url("roi-calculator", investment_length: 30, investment_period: "days")

    assert_select "p", text: "Not shown for periods under a year."
  end

  test "401k calculator asks for a share of salary and names the limit year" do
    get tool_url("401k-retirement-calculator")

    assert_select "label[for=monthly_contribution]", text: "Contribution (% of salary)"
    assert_select "p", text: /capped at the 2026 IRS limit/
  end

  test "early mortgage payoff asks only for what it amortizes" do
    get tool_url("early-mortgage-payoff-calculator", original_term: 15)

    assert_select "label[for=loan_amount]", text: "Remaining balance"
    assert_select "input[name=original_term]", count: 0
  end

  test "financial freedom growth rate slider starts at the percentage" do
    get tool_url("financial-freedom-calculator")

    assert_select "input[type=range][max='20']" do |slider|
      assert_in_delta 7.0, slider.first["value"].to_f
    end
  end

  test "loan calculator start date is an ISO date without an upper bound" do
    travel_to Date.new(2026, 10, 20) do
      get tool_url("loan-calculator")
    end

    assert_select "input[type=date][name=date][value='2026-10-20']:not([max])"
  end

  test "loan calculator accepts future start dates and survives unparseable ones" do
    get tool_url("loan-calculator", date: "2030-01-15", loan_term: 1)
    assert_select "p", text: "January 15th, 2031"

    get tool_url("loan-calculator", date: "10/20/2026")
    assert_response :success
  end
end
