require "test_helper"

class RoadmapControllerTest < ActionDispatch::IntegrationTest
  test "roadmap page renders curated phases from markdown" do
    get roadmap_url

    assert_response :success
    assert_select "title", text: "Roadmap - Sure"
    assert_select "h1", text: "The Sure roadmap"
    assert_select "details", count: 3
    assert_select "details:not([open])", count: 3
    assert_select "summary", text: /Stabilize and polish the core/
    assert_select "h2", text: "Reliability, performance, and technical debt"
    assert_select "a[href='/'] img[alt='Sure']"
  end
end
