require "test_helper"

class Tool::Presenter::RoiCalculatorTest < ActiveSupport::TestCase
  setup do
    @tool = Tool::Presenter::RoiCalculator.new \
      amount_invested: "$50,500.00",
      amount_returned: "$60,000.00",
      investment_length: "5",
      investment_period: "years"
  end

  test "investment gain" do
    assert_equal 9_500.0, @tool.investment_gain
  end

  test "roi" do
    assert_equal 18.81, @tool.roi
  end

  test "annualized roi" do
    assert_equal 3.51, @tool.annualized_roi

    doubled_in_ten_years = Tool::Presenter::RoiCalculator.new(
      amount_invested: "$10,000.00",
      amount_returned: "$20,000.00",
      investment_length: "10",
      investment_period: "years"
    )
    assert_equal 7.18, doubled_in_ten_years.annualized_roi
  end

  test "annualized roi needs at least a year" do
    assert_nil Tool::Presenter::RoiCalculator.new(investment_length: "51", investment_period: "weeks").annualized_roi
    assert_equal 4.9, Tool::Presenter::RoiCalculator.new(
      amount_invested: "$10,000.00",
      amount_returned: "$11,000.00",
      investment_length: "104",
      investment_period: "weeks"
    ).annualized_roi
  end

  test "roi sign" do
    assert_equal "+", @tool.roi_sign
    assert_nil Tool::Presenter::RoiCalculator.new(
      amount_invested: "$50,500.00",
      amount_returned: "$40,000.00",
      investment_length: "5",
      investment_period: "years"
    ).roi_sign
  end
end
