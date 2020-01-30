module Api
  module V1
    class ScannerController < ApplicationController
      def index
        item = Item.order("created_at DESC");
        render json: {status: 'SUCCESS', message: 'Loaded Scanned In Items', data:item},status: :ok
      end

      def show
        item = Item.find(params[:barcode])
        render json: {status: 'SUCCESS', message: 'Loaded Scanned In Item', data:item},status: :ok
      end

      def create
        item = Item.new(item_params)

        if item.save
          render json: {status: 'SUCCESS', message: 'Saved New Item', data:item},status: :ok
        else
          render json: {status: 'ERROR', message: 'Item Not Saved', data:item.errors},status: :unprocessable_entity
        end
      end

      def destroy
        item = Item.find_by_barcode(params[:barcode])
        Item.destroy
        render json: {status: 'SUCCESS', message: 'Item Removed From Database', data:item},status: :ok
      end

      def update
        item = Item.find_by_barcode(params[:barcode])
        if item
         item.count = item.count + 1
         if item.update_attributes(item_params)
           render json: {status: 'SUCCESS', message: 'Updated Item', data:item},status: :ok
        else
          render json: {status: 'ERROR', message: 'Item Not Found In DB', data:item.errors},status: :unprocessable_entity

      private

      def item_params
        params.require(:item).permit(:name, :description, :count, :barcode_id, :category_id)
      end
    end
  end
end
