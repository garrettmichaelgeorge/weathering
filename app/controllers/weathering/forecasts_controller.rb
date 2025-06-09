class Weathering::ForecastsController < ApplicationController
  def show
    @forecast = Weathering::Forecast.new
    @forecast.address = forecast_params.dig(:weathering_forecast, :address)

    return unless @forecast.address.present?

    # Fetch geocode
    logger.debug { "Fetching geocode for #{@forecast.address}" }
    geocode_results = Geocoder.search(@forecast.address)
    geocode_result = geocode_results.first

    return unless geocode_result.present?

    @forecast.full_address = geocode_result.address

    logger.debug { "Got geocode for address input '#{@forecast.address}'. Full address: '#{@forecast.full_address}'" }

    # Fetch forecast
    forecast_result =
      if geocode_result.postal_code.present?
        Rails.cache.fetch("/forecasts/#{geocode_result.postal_code}", expires_in: 30.minutes) do
          fetch_forecast(geocode_result.coordinates)
        end
      else
        fetch_forecast(geocode_result.coordinates)
      end

    @forecast.current_temperature = forecast_result["current"]["temperature_2m"]
    @forecast.current_temperature_unit = forecast_result["current_units"]["temperature_2m"]

    logger.debug { "Got current temperature #{@forecast.current_temperature_with_unit} at postal code #{geocode_result.postal_code}" }
  end

  private

  def forecast_params
    params.permit(weathering_forecast: [:address])
  end

  def fetch_forecast(coordinates)
    client = OpenMeteo::Client.new(coordinates)
    client.fetch_forecast
  end
end
