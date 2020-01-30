module Api
  module V1
    class ScannedOutsController < ApplicationController

      skip_before_action :require_login
      
      def index
        item = item.order("created_at DESC");
        render json: {status: 'SUCCESS', message: 'Loaded Scanned Out Items', data:item},status: :ok
      end

      def show
        item = Item.find(params[:barcode])
        render json: {status: 'SUCCESS', message: 'Loaded Scanned Out Item', data:item},status: :ok
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
         item.count = item.count - 1
         if item.update_attributes(item_params)
           render json: {status: 'SUCCESS', message: 'Updated Item', data:item},status: :ok
         end
        else
          render json: {status: 'ERROR', message: 'Item Not Found In DB', data:item.errors},status: :unprocessable_entity
        end
      end

      def process_remove_scanner
        item = Item.find_by_barcode_id(params[:barcode])
        if item
          item.count = item.count - 1
          if item.update_attributes(item_update)
            scanned_out_record = ScannedOut.new
            scanned_out_record.count = 1
            scanned_out_record.item_id = item.id
            if scanned_out_record.save
              render json: {status: 'SUCCESS', message: 'Saved New scanned out Item', data:item},status: :ok
            else
              render json: {status: 'ERROR', message: 'nice try kid', data:item},status: :unprocessable_entity
            end
          else
            render json: {status: 'ERROR', message: 'not Updated scanned out item', data:item},status: :unprocessable_entity
          end
        else
          render json: {status: 'ERROR', message: 'Item Not Found In DB', data:item.errors},status: :unprocessable_entity
        end
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :count, :barcode_id, :category_id)
      end

      def item_update
        params.permit(:barcode_id)
      end

    end
  end
end
