module Api
  module V1
    class CategoriesController < ApplicationController

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
        @category = Category.find(params[:id])
        if @category.update_attributes(category_params)
          render json: {status: 'SUCCESS', message: 'updated category', data:@category},status: :ok
        else
          render('edit')
          render json: {status: 'Failed', message: 'didnt update category', data:@category.errors.full_messages},status: :unprocessable_entity
        end
      end

      def destroy
        @category = Category.find(params[:id])
        @category.destroy
        render json: {status: 'SUCCESS', message: 'deleted category', data:@category},status: :ok

      end

      private

      def category_params
        params.require(:category).permit(:name)
      end

    end
  end
end