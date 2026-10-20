require "test_helper"

class BankSearchControllerTest < ActionDispatch::IntegrationTest
  test "index asks search engines not to index it" do
    get bank_search_url

    assert_response :success
    assert_select "meta[name='robots'][content='noindex']"
    assert_no_match(/Search Ready/, response.body)
  end
end
