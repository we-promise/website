require "test_helper"

class ToolsControllerTest < ActionDispatch::IntegrationTest
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
