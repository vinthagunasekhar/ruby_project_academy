require "test_helper"

class CryptosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cryptos_index_url
    assert_response :success
  end

  test "should get details" do
    get cryptos_details_url
    assert_response :success
  end
end
