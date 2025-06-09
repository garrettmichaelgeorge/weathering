require "application_system_test_case"

class ForecastsTest < ApplicationSystemTestCase
   # When I visit the homepage
   # And I fill in the address field with "1 Apple Park Way, Cupertino, CA 95014"
   # And I click, "Get Weather"
   # Then I should see the temperature in degrees F
   test "visiting the index" do
     visit root_url

     fill_in "Address", with: "1 Apple Park Way, Cupertino, CA 95014"
     click_on("Get forecast")

     assert_text "°F"
   end
end
