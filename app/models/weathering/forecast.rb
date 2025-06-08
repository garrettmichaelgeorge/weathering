module Weathering
  class Forecast
    include ActiveModel::Model
    attr_accessor :current_temperature, :current_temperature_unit, :address

    def current_temperature_with_unit
      return nil unless current_temperature.present?

      "#{current_temperature} #{current_temperature_unit}"
    end
  end
end
