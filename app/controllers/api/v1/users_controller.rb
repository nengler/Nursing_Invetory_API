module Api
  module V1
    class UsersController < ApplicationController

      skip_before_action :require_login

      def create
        @user = User.new(user_params)
        
        if @user.save
          render json: {status: 'SUCCESS', message: 'saved user', data:@user},status: :ok
        else
          render json: {status: 'Failed', message: 'didnt save user', data:@user.errors},status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:password)
      end

    end
  end
end
