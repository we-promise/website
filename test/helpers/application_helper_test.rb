require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "image_tag_2x lays a 2x image out at its 1x width" do
    tag = image_tag_2x("features/assistant-chat-rule.webp", width: 320, height: 270, alt: "Chat")

    assert_match(/srcset="[^"]*assistant-chat-rule[^"]*\.webp 640w"/, tag)
    assert_includes tag, 'sizes="320px"'
    assert_includes tag, 'width="320"'
    assert_includes tag, 'height="270"'
  end
end
