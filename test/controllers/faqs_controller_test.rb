require "test_helper"

class FaqsControllerTest < ActionDispatch::IntegrationTest
  test "should get show for an existing FAQ" do
    faq = Faq.create!(question: "What is an index fund?", answer: "A fund that tracks a market index.", slug: "what-is-an-index-fund")

    get faq_url(faq)

    assert_response :success
  end

  test "returns not found for an unknown FAQ" do
    get faq_url("non-existent-faq")
    assert_response :not_found
  end
end
