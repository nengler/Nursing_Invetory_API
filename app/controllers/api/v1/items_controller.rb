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

      def item_by_name
        @item = Item.where("name like ?", "%#{params[:name]}%")
        render json: {status: 'SUCCESS', message: 'got item(s)', data:@item},status: :ok
      end

      def index
        items = Item.includes(:category)
        items.each do |item|
          item.category_name = item.category.name
        end
        render json: {status: 'SUCCESS', message: 'got items', data:items},status: :ok
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
          render json: {status: 'Failed', message: 'didnt create item', data:@item.errors},status: :ok
        end
      end

      def show
        item = Item.find_by_barcode(params[:barcode])
        if item
          render json: {status: 'SUCCESS', message: 'item found', data:item},status: :ok
        else
          render json: {status: 'ERROR', message: 'Item Not Found In DB', data:"item not found"},status: :ok
        end
      end

      def edit
        @item = Item.find(params[:id])
        render json: {status: 'SUCCESS', message: 'item found', data:@item},status: :ok
      end

      def update
        @item = Item.find(params[:id])
        namee =  params.require(:item).permit(:name)
        check_for_duplicate_names = Item.where(name: namee[:name]).first
        if(check_for_duplicate_names == nil || @item.id == check_for_duplicate_names.id)
          if @item.update(item_params)
            render json: {status: 'SUCCESS', message: 'item updated', data:@item},status: :ok
          else
            render json: {status: 'Failed', message: 'didnt update item', data:@item},status: :ok
          end
        else
          render json: {status: 'SUCCESS', message: 'item updated', error:"duplicate entry"},status: :unprocessable_entity
        end
      end

      def destroy
        @item = Item.find(params[:id])
        @item.destroy
        render json: {status: 'SUCCESS', message: 'item deleted', data:@item},status: :ok
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :count, :barcode, :category_id, :threshold, :cost)
      end

    end
  end
end