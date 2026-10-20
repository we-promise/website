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
