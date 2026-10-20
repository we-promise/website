require "test_helper"

class TermsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @term = Term.create!(
      name: "Test Term",
      title: "Test Term Title",
      slug: "test-term",
      content: "This is the full content of the test term"
    )
  end

  test "should get index" do
    get terms_url
    assert_response :success
  end

  test "suggested terms link to term pages" do
    get terms_url
    assert_select "a.rounded-full[href^='/financial-terms/']"
    assert_select "a[href='#']", count: 0
  end

  test "should get index with search query" do
    get terms_url, params: { q: "test" }
    assert_response :success
  end

  test "should get show for existing term" do
    get term_url(@term.slug)
    assert_response :success
  end

  test "returns not found for an unknown term" do
    get term_url("non-existent-term")
    assert_response :not_found
  end
end
