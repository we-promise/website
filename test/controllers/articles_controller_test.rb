require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get articles_url
    assert_response :success
    assert_select "a[href='#{still_shipping_path}']", text: /last image wasn.t the last chapter/i
  end

  test "index renders when there are no articles" do
    Article.delete_all

    get articles_url

    assert_response :success
  end

  test "should get show" do
    get article_url(articles(:one))
    assert_response :success
  end

  test "returns not found for an unknown article" do
    get article_url("non-existent-article")
    assert_response :not_found
  end
end
