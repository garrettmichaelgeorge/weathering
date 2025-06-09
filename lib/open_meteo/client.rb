module OpenMeteo
  class Client
    attr_reader :conn

    def initialize(coordinates)
      @conn = Faraday.new(
        url: "https://api.open-meteo.com",
        params: {
          latitude: coordinates[0],
          longitude: coordinates[1],
          daily: "temperature_2m_max,temperature_2m_min",
          current: "temperature_2m",
          timezone: "auto",
          forecast_days: 1,
          temperature_unit: "fahrenheit"
        },
        headers: {"Content-Type" => "application/json"}
      ) do |builder|
        builder.request :json
        builder.response :json
        builder.response :raise_error
      end
    end

    def fetch_forecast
      begin
        response = @conn.get("/v1/forecast")
      rescue Faraday::Error => e
        logger.error { "Error getting forecast at #{e.response[:url]}. Status #{e.response[:status]} with body #{e.response[:body]}" }
      end

      response.body
    end
  end
end
