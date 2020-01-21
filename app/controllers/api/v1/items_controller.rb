module Api
  module V1
    class ItemsController < ApplicationController

      def index
        @items = Item.all
        render json: {status: 'SUCCESS', message: 'got items', data:@items},status: :ok
      end
      
      def new
        @item = Item.new
        @categories = Category.all
        @response = {:item => @item, :categories => categories}
      end

      def create
        @item = Item.new(item_params)

        if @item.save
          render json: {status: 'SUCCESS', message: 'item saved', data:@item},status: :ok
        else
          @categories = Category.all
          @response = {:categories => @categories, :errors => @item.errors}
          render json: {status: 'Failed', message: 'didnt create item', data:@response},status: :unprocessable_entity
        end
      end

      def show
        @item = Item.find(params[:id])
        render json: {status: 'SUCCESS', message: 'item found', data:@item},status: :ok
      end

      def edit
        @item = Item.find(params[:id])
        render json: {status: 'SUCCESS', message: 'item found', data:@item},status: :ok
      end

      def update
        @item = Item.find(params[:id])
        if @item.update_attributes(item_params)
          render json: {status: 'SUCCESS', message: 'item updated', data:@item},status: :ok
        else
          render json: {status: 'Failed', message: 'didnt update item', data:@item},status: :unprocessable_entity
        end
      end

      def destroy
        @item = Item.find(params[:id])
        @item.destroy
        render json: {status: 'SUCCESS', message: 'item deleeted', data:@item},status: :ok

      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :count, :barcode_id, :category_id)
      end

    end
  end
end