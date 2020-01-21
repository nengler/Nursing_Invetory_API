module Api
  module V1
    class AuthController < ApplicationController

      skip_before_action :require_login

      def login
        user = User.find_by_id(params[:id])
        if user && user.authenticate(params[:password])
          payload = {user_id: user.id}
          token = encode_token(payload)
          render json: {user: user, jwt: token, success: "Welcome back"}
        else
          render json: {failure: "log in failed! invalid username password combo"}
        end
      end

      def auto_login
        if session_user
          render json: session_user
        else
          render json: {errors: "no users logged in"}
        end
      end

    end
  end
end