module Api
  module V1
    class ScannedInsController < ApplicationController

      skip_before_action :require_login

      def grab_last_5
        last_5_scanned_in = ScannedIn.last_created
        render json: {status: 'SUCCESS', message: '5 items got', data:last_5_scanned_in},status: :ok
      end
    end
  end
end