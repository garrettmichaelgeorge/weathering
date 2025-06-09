require "application_system_test_case"

class ForecastsTest < ApplicationSystemTestCase
  # TODO: use mocks for external API calls
  test "fetching the forecast" do
    visit root_url

    fill_in "Address", with: "1 Apple Park Way, Cupertino, CA 95014"
    click_on "Get forecast"

    assert_text "°F"
  end
end
