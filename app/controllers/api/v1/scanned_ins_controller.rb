module Api
  module V1
    class ScannedInsController < ApplicationController

      skip_before_action :require_login

      def grab_last_5
        last_5_scanned_in = ScannedIn.last_created
        last_5_item_ids = []
        last_5_scanned_in.each do |item|
          last_5_item_ids.push(item.item_id)
        end
        corresponding_items = Item.includes(:scanned_in).where(items: {id: last_5_item_ids})
        last_5_scanned_in.each do |scanned_in|
          corresponding_items.each do |item|
            if(scanned_in.item_id == item.id)
              scanned_in.name = item.name
              scanned_in.description = item.description
            end
          end
        end
        render json: {status: 'SUCCESS', message: '5 items got', data:last_5_scanned_in.reverse},status: :ok
      end

      def process_scan_in
        item = Item.find_by_barcode(params[:barcode])
        count = params[:count].to_i
        if item
          item.count = item.count + count
          if item.update_attributes(item_update)
            scanned_in_record = ScannedIn.create(count: count, item_id: item.id)
            if scanned_in_record.save
              render json: {status: 'SUCCESS', message: 'Saved New scanned in Item', data:item},status: :ok
            else
              render json: {status: 'ERROR', message: 'nice try kid', data:item},status: :ok
            end
          else
            render json: {status: 'ERROR', message: 'not Updated scanned in item', data:item},status: :ok
          end
        else
          render json: {status: 'ERROR', message: 'Item Not Found In DB', data:"item not found"},status: :ok
        end
      end

      private

      def item_update
        params.permit(:barcode_id)
      end

    end
  end
end