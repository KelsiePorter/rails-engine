class Api::V1::Items::MerchantController < ApplicationController
  def show
    begin
      item = Item.find(params[:item_id])
      render json: MerchantSerializer.new(item.merchant)
    rescue StandardError => e
      error_item = ErrorItem.new(
        e.message, 
        "NOT FOUND",
        404
      )
      render json: ErrorItemSerializer.new(error_item).serialized_json
    end
  end
end