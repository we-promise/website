require "test_helper"

class FeaturesControllerTest < ActionDispatch::IntegrationTest
  test "AI feature page renders its user-choice principle" do
    get features_ai_url

    assert_response :success
    assert_select "title", text: /Your money\. Your data\. Your choice\./
    assert_select "h1 strong", text: "Your money."
    assert_select "h1 em", text: "Your data."
    assert_select "h1", text: /Your money\. Your data\. Your choice\./
    assert_select "[aria-label='Illustration of Sure AI controls']", count: 0
    assert_select "p", text: /AI in Sure is optional and off by default/
    assert_select "p", text: /using any of the app/
    assert_select "p", text: /Sure's AI is optional/, count: 0
    assert_select "p", text: /Always your choice/, count: 0
    assert_select "h3", text: "Assistant"
    assert_select "h3", text: "Auto-categorize transactions"
    assert_select "h3", text: "Merchant detection"
    assert_select "h3", text: "Generated Insights"
    assert_select "h3", text: "PDFs and documents"
    assert_select "p", text: /leaves the transaction unassigned/
    assert_select "p", text: /deterministic template/
    assert_select "p", text: /reviewable import rows/
    assert_select "p", text: /custom OpenAI-compatible endpoint/
    assert_select "p", text: /Ollama and Open WebUI/
    assert_select "p", text: /local weights by default/
    assert_select "a[href='https://github.com/we-promise/sure']", count: 2
    assert_select "a[href='https://github.com/we-promise/sure']", text: "Explore the code"
    assert_select "a[href='https://github.com/we-promise/sure']", text: "View the source"
    assert_select "a[href='#{new_signup_path}']", count: 0
  end

  test "legacy AI paths redirect to the new feature page" do
    [ "/ai", "/features/assistant", "/features/assistant/spending", "/features/assistant/spending/content" ].each do |path|
      get path

      assert_redirected_to "/features/ai"
      assert_response :moved_permanently
    end
  end
end
