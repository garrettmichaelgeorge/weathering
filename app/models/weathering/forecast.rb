module Weathering
  class Forecast
    include ActiveModel::Model

    attr_accessor :current_temperature, :current_temperature_unit, :address, :full_address

    # Returns a human-friendly string with the temperature and unit
    def current_temperature_with_unit
      return nil unless current_temperature.present?

      "#{current_temperature} #{current_temperature_unit}"
    end
  end
end
