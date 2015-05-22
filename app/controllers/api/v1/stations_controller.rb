module API
  module V1
    class StationsController < BaseController
      def index
        @stations = Station.all
      end
    end
  end
end
