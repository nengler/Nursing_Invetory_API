module Api
  module V1
    class ItemsController < ApplicationController

      skip_before_action :require_login

      def items_below_threshold
        sortedBelowThresholdItems = Hash.new
        below_threshold_items = Item.where('count < threshold');
        below_threshold_items.each do |item|
          unless sortedBelowThresholdItems[item.category_id].present?
            sortedBelowThresholdItems[item.category_id] = Array.new
          end
          sortedBelowThresholdItems[item.category_id].push(item)
        end
        categories = Category.all
        categories.each do |category|
          if sortedBelowThresholdItems[category.id].present?
            sortedBelowThresholdItems[category.name] = sortedBelowThresholdItems.delete(category.id)
          end
        end
        render json: {status: 'SUCCESS', message: 'got items', data:sortedBelowThresholdItems},status: :ok
      end

      def filter_items
        sortedItemByCategory = Hash.new
        items = Item.all
        items.each do |item|
          unless sortedItemByCategory[item.category_id].present?
            sortedItemByCategory[item.category_id] = Array.new
          end
          sortedItemByCategory[item.category_id].push(item)
        end
        categories = Category.all
        categories.each do |category|
          sortedItemByCategory[category.name] = sortedItemByCategory.delete(category.id)
        end
        render json: {status: 'SUCCESS', message: 'got items', data:sortedItemByCategory},status: :ok
      end

      def items_by_category
        @items = Item.where(category_id: params[:category_id])
        render json: {status: 'SUCCESS', message: 'got items', data:@items},status: :ok
      end

      def item_by_name
        @item = Item.where("name like ?", "%#{params[:name]}%")
        render json: {status: 'SUCCESS', message: 'got item(s)', data:@item},status: :ok
      end

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
          render json: {status: 'Failed', message: 'didnt create item', data:@item.errors},status: :bad_request
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
        params.require(:item).permit(:name, :description, :count, :barcode, :category_id)
      end

    end
  end
end