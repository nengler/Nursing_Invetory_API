module Api
  module V1
    class ScannedOutsController < ApplicationController

      skip_before_action :require_login

      #trend report logic
      def items_by_category
        puts(params)
        scanned_out_sorted = Hash.new
        scanned_out_sorted_by_category = Hash.new
        scanned_out_items = ScannedOut.includes(:item).where(scanned_outs: {created_at: params[:start_date]..params[:end_date]})
        scanned_out_items.each do |sc_item|
          if scanned_out_sorted[sc_item.item_id].present?
            scanned_out_sorted[sc_item.item_id].count += sc_item.count
            if sc_item.updated_at > scanned_out_sorted[sc_item.item_id].updated_at
              scanned_out_sorted[sc_item.item_id].updated_at = sc_item.updated_at
            end
          else
            sc_item.name = sc_item.item.name
            sc_item.description = sc_item.item.description
            sc_item.category_id = sc_item.item.category_id
            scanned_out_sorted[sc_item.item_id] = sc_item
          end
        end

        scanned_out_sorted.each_value {|sc_value| 
          unless scanned_out_sorted_by_category[sc_value.category_id].present?
            scanned_out_sorted_by_category[sc_value.category_id] = Array.new
          end
          scanned_out_sorted_by_category[sc_value.category_id].push(sc_value)
          }

        categories = Category.all
        categories.each do |category|
          scanned_out_sorted_by_category[category.name] = scanned_out_sorted_by_category.delete(category.id.to_s)
        end
        render json: {status: 'SUCCESS', message: 'got items', data:scanned_out_sorted_by_category},status: :ok
      end

      #last 5 scanned out
      def grab_last_5
        last_5_scanned_out = ScannedOut.last_created
        last_5_item_ids = []
        last_5_scanned_out.each do |item|
          last_5_item_ids.push(item.item_id)
        end
        corresponding_items = Item.includes(:scanned_out).where(items: {id: last_5_item_ids})
        last_5_scanned_out.each do |scanned_out|
          corresponding_items.each do |item|
            if(scanned_out.item_id == item.id)
              scanned_out.name = item.name
              scanned_out.description = item.description
            end
          end
        end
        render json: {status: 'SUCCESS', message: '5 items got', data:last_5_scanned_out.reverse},status: :ok
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
        item = Item.find_by_barcode(params[:barcode])
        count = params[:count].to_i
        if item
          item.count = item.count - count
          if item.update_attributes(item_update)
            scanned_out_record = ScannedOut.create(count: count, item_id: item.id)
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