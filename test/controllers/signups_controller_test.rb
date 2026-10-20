require "test_helper"

class SignupsControllerTest < ActionDispatch::IntegrationTest
  include WebMock::API

  KIT_SUBSCRIBE_URL = %r{\Ahttps://api\.convertkit\.com/v3/forms/[^/]*/subscribe\z}

  teardown { WebMock.reset! }

  test "offers release updates by email" do
    get new_signup_url

    assert_response :success
    assert_select "input[type=submit][value='Get updates']"
    assert_no_match(/waitlist/i, response.body)
  end

  test "confirms the signup when ConvertKit accepts the subscriber" do
    stub_request(:post, KIT_SUBSCRIBE_URL)
      .with(body: hash_including("email" => "person@example.com"))
      .to_return(status: 200, body: '{"subscription":{"id":1}}')

    post signups_url, params: { email: "person@example.com" }

    assert_response :success
    assert_select "turbo-frame#signup_form", text: /We'll email you/
  end

  test "shows an error when ConvertKit rejects the subscriber" do
    stub_request(:post, KIT_SUBSCRIBE_URL).to_return(status: 401, body: '{"error":"Authorization Failed"}')

    post signups_url, params: { email: "person@example.com" }

    assert_response :unprocessable_content
    assert_select "turbo-frame#signup_form", text: /couldn't sign you up/
  end

  test "shows an error when ConvertKit can't be reached" do
    stub_request(:post, KIT_SUBSCRIBE_URL).to_timeout

    post signups_url, params: { email: "person@example.com" }

    assert_response :unprocessable_content
    assert_select "turbo-frame#signup_form", text: /couldn't sign you up/
  end
end
