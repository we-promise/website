require "test_helper"

class Tool::Presenter::RetirementCalculatorTest < ActiveSupport::TestCase
  setup do
    @tool = Tool::Presenter::RetirementCalculator.new \
      retirement_age: "65",
      current_age: "35",
      annual_salary: "$120,000.00",
      current_401k_balance: "$100,000.00",
      annual_rate_of_return: "5",
      monthly_contribution: "15",
      annual_salary_increase: "3",
      employer_match: "50",
      salary_limit_match: "6"
  end

  test "current total value" do
    assert_equal 2_531_629.95, @tool.current_total_value.round(2)
  end

  test "total employee contributions" do
    assert_equal 815_426.61, @tool.total_employee_contributions.round(2)
  end

  test "total employer contributions" do
    assert_equal 171_271.50, @tool.total_employer_contributions.round(2)
  end

  test "plot data" do
    travel_to Date.new(2024, 9, 24) do
      first_plot_point = {
        year: 1,
        date: Date.today + 1.year,
        contributed: 18_000.00,
        interest: 21_600.00,
        currentTotalValue: 127_310.22108926918,
        totalEmployeeContributions: 18_000.0,
        totalEmployerContributions: 3_600.0 }
      last_plot_point = {
        year: 30,
        date: Date.today + 30.years,
        contributed: 815_426.613275857,
        interest: 986_698.1098186162,
        currentTotalValue: 2_531_629.9542212663,
        totalEmployeeContributions: 815_426.613275857,
        totalEmployerContributions: 171_271.4965427593 }

      assert_equal first_plot_point, @tool.plot_data.first
      assert_equal last_plot_point, @tool.plot_data.last
    end
  end

  test "employee contributions are capped at the 2026 IRS limit for their age" do
    tool = Tool::Presenter::RetirementCalculator.new \
      annual_salary: "$300,000.00",
      monthly_contribution: "50",
      annual_salary_increase: "0",
      current_age: "48",
      retirement_age: "66"

    yearly = [ 0, *tool.plot_data.pluck(:totalEmployeeContributions) ].each_cons(2).map { |before, after| after - before }

    # ages 48-49, 50-59, 60-63 and 64-65
    assert_equal [ 24_500 ] * 2 + [ 32_500 ] * 10 + [ 35_750 ] * 4 + [ 32_500 ] * 2, yearly
  end

  test "legend names the contribution totals it plots" do
    assert_equal({ contributed: "Employee contributions", interest: "Total contributions" },
      @tool.legend_data.transform_values { it[:name] })
  end
end
