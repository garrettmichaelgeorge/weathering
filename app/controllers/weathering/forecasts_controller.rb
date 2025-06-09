class Weathering::ForecastsController < ApplicationController
  def show
    @forecast = Weathering::Forecast.new
    @forecast.address = forecast_params.dig(:weathering_forecast, :address)

    if @forecast.address.present?
      logger.debug { "Fetching geocode for #{@forecast.address}" }
      geocode_results = Geocoder.search(@forecast.address)
      geocode_result = geocode_results.first
      logger.debug { "Got coordinates #{geocode_result.coordinates} at postal code #{geocode_result.postal_code}" }

      forecast = fetch_forecast(geocode_result.coordinates)
      logger.debug "Fetched forecast #{forecast}"
      @forecast.current_temperature = forecast["current"]["temperature_2m"]
      @forecast.current_temperature_unit = forecast["current_units"]["temperature_2m"]
      logger.debug { "Got current temperature #{@forecast.current_temperature_with_unit} at postal code #{geocode_result.postal_code}" }
    end
  end

  private

  def forecast_params
    params.permit(weathering_forecast: [ :address ])
  end

  def fetch_forecast(coordinates)
    conn = Faraday.new(
      url: "https://api.open-meteo.com",
      params: { latitude: coordinates[0], longitude: coordinates[1], daily: "temperature_2m_max,temperature_2m_min", current: "temperature_2m", timezone: "auto", forecast_days: 1, temperature_unit: "fahrenheit" },
      headers: { "Content-Type" => "application/json" }
    ) do |builder|
      builder.request :json
      builder.response :json
      builder.response :raise_error
    end

    begin
      response = conn.get("/v1/forecast")
    rescue Faraday::Error => e
      logger.error { "Error getting forecast at #{e.response[:url]}. Status #{e.response[:status]} with body #{e.response[:body]}" }
    end

    response.body
  end
end
