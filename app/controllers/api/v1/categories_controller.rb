module Api
  module V1
    class CategoriesController < ApplicationController

      skip_before_action :require_login
      
      def index
        @categories = Category.all
        render json: {status: 'SUCCESS', message: 'got categories', data:@categories},status: :ok
      end

      def new
        @category = Category.new
        render json: {status: 'SUCCESS', message: 'new category', data:@category},status: :ok
      end

      def create
        @category = Category.new(category_params)

        if @category.save
          render json: {status: 'SUCCESS', message: 'saved category', data:@category},status: :ok
        else
          render json: {status: 'Failed', message: 'didnt create category', data:@category.errors.full_messages},status: :unprocessable_entity
        end
      end

      def show
        @category = Category.find(params[:id])
        render json: {status: 'SUCCESS', message: 'got category', data:@category},status: :ok
      end

      def edit
        @category = Category.find(params[:id])
        render json: {status: 'SUCCESS', message: 'got category', data:@category},status: :ok
      end

      def update
        namee =  params.require(:category).permit(:name, :old_name)
        category = Category.find_by_name(namee[:old_name])
        check_for_duplicate_names = Category.where(name: namee[:name]).first
        if(check_for_duplicate_names == nil || category.id == check_for_duplicate_names.id)
          if category.update(category_params)
            puts("init")
            render json: {status: 'SUCCESS', message: 'updated category', data:category},status: :ok
          else
            puts("not init")
            render json: {status: 'Failed', message: 'didnt update category', data:category.errors.full_messages},status: :unprocessable_entity
          end
        else
          puts("oh no")
          render json: {status: "Failed", message: "category already exists", data: "category already exists"},status: :unprocessable_entity
        end
      end

      def destroy
        category = Category.find_by_name(params[:name])
        category.destroy
        render json: {status: 'SUCCESS', message: 'deleted category', data:category},status: :ok
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end

    end
  end
end