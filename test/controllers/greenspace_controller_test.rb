require "test_helper"

class GreenspaceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get greenspace_index_url
    assert_response :success
  end

  test "should get show" do
    get greenspace_show_url
    assert_response :success
  end
end
