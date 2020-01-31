module Api
  module V1
    class ScannedOutsController < ApplicationController

      skip_before_action :require_login

      def items_by_category
        scanned_out_sorted = Hash.new
        scanned_out_items = ScannedOut.includes(:item).where(items: {category_id: params[:category_id]}, scanned_outs: {created_at: params[:start_date]..params[:end_date]})
        scanned_out_items.each do |item|
          if scanned_out_sorted[item.item_id].present?
            scanned_out_sorted[item.item_id].count += item.count
            if item.updated_at > scanned_out_sorted[item.item_id].updated_at
              scanned_out_sorted[item.item_id].updated_at = item.updated_at
            end
          else
            item.name = item.item.name
            item.description = item.item.description
            scanned_out_sorted[item.item_id] = item
          end
        end
        render json: {status: 'SUCCESS', message: 'got items', data:scanned_out_sorted},status: :ok
      end

      def index
        scanned_out_items = ScannedOut.all
        render json: {status: 'SUCCESS', message: 'got items', data:scanned_out_items},status: :ok
      end

      def create
        @scanned_out_item = ScannedOut.new(scanned_out_item_params)

        if @scanned_out_item.save
          render json: {status: 'SUCCESS', message: 'item saved', data:@scanned_out_item},status: :ok
        else
          render json: {status: 'Failed', message: 'didnt create item', data:@scanned_out_item.errors},status: :unprocessable_entity
        end
      end
      
      def process_scan_out
        item = Item.find_by_barcode_id(params[:barcode])
        if item
          item.count = item.count - 1
          if item.update_attributes(item_update)
            scanned_out_record = ScannedOut.create(count: 1, item_id: item.id)
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

      def scanned_out_item_params
        params.permit(:count, :name, :item_id, :category_id)
      end

      def item_update
        params.permit(:barcode_id)
      end

    end
  end
end