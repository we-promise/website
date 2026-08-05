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

  test "rejects a roadmap without the version marker" do
    path = Rails.root.join("tmp", "invalid-roadmap.md")
    File.write(path, "## Phase: Now\nDescription: Something\n### Item: Work\nStatus: Planned\n")

    assert_raises(RoadmapParser::ParseError) { RoadmapParser.new(path).parse }
  ensure
    File.delete(path) if path&.exist?
  end
end
