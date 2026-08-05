require "test_helper"

class RoadmapParserTest < ActiveSupport::TestCase
  test "parses the curation markdown into phases and items" do
    roadmap = <<~MARKDOWN
      <!-- roadmap:v1 -->

      ## Phase: Now
      Description: Keep the foundation steady

      ### Item: Make it faster
      Status: In progress
      Description: Improve the everyday experience.

      ## Phase: Later
      Description: Expand thoughtfully

      ### Item: Go further
      Status: Planned
    MARKDOWN
    path = Rails.root.join("tmp", "roadmap-parser-test.md")
    File.write(path, roadmap)

    result = RoadmapParser.new(path).parse

    assert_equal "Now", result.first[:title]
    assert_equal "Keep the foundation steady", result.first[:description]
    assert_equal "In progress", result.first[:items].first[:status]
    assert_equal "Improve the everyday experience.", result.first[:items].first[:description]
    assert_nil result.last[:items].first[:description]
  ensure
    File.delete(path) if path&.exist?
  end

  test "parses an injected markdown string" do
    roadmap = "<!-- roadmap:v1 -->\n\n## Phase: Now\nDescription: Keep going\n\n### Item: Ship it\nStatus: Planned\n"

    result = RoadmapParser.new(roadmap).parse

    assert_equal "Ship it", result.first[:items].first[:title]
  end

  test "fetches the canonical roadmap with short timeouts" do
    response = mock
    response.expects(:is_a?).with(Net::HTTPSuccess).returns(true)
    response.expects(:body).returns("<!-- roadmap:v1 -->\n\n## Phase: Now\nDescription: Keep going\n\n### Item: Ship it\nStatus: Planned\n")
    http = mock
    http.expects(:get).with("/we-promise/sure/main/docs/roadmap.md").returns(response)
    Net::HTTP.expects(:start).with(
      "raw.githubusercontent.com",
      443,
      use_ssl: true,
      open_timeout: 1,
      read_timeout: 1
    ).yields(http).returns(response)

    result = RoadmapParser.new(RoadmapParser::DEFAULT_SOURCE_URL, open_timeout: 1, read_timeout: 1).parse

    assert_equal "Ship it", result.first[:items].first[:title]
  end

  test "raises a clear parse error when fetching fails" do
    response = mock
    response.expects(:is_a?).with(Net::HTTPSuccess).returns(false)
    response.expects(:code).returns("503")
    http = mock
    http.expects(:get).with("/roadmap.md").returns(response)
    Net::HTTP.expects(:start).with(
      "example.test",
      443,
      use_ssl: true,
      open_timeout: 2,
      read_timeout: 2
    ).yields(http).returns(response)

    error = assert_raises(RoadmapParser::ParseError) do
      RoadmapParser.new("https://example.test/roadmap.md").parse
    end

    assert_includes error.message, "HTTP 503"
  end

  test "rejects a roadmap without the version marker" do
    path = Rails.root.join("tmp", "invalid-roadmap.md")
    File.write(path, "## Phase: Now\nDescription: Something\n### Item: Work\nStatus: Planned\n")

    assert_raises(RoadmapParser::ParseError) { RoadmapParser.new(path).parse }
  ensure
    File.delete(path) if path&.exist?
  end
end
