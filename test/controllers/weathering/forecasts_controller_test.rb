require "test_helper"

class Weathering::ForecastsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get weathering_forecasts_show_url
    assert_response :success
  end
end
