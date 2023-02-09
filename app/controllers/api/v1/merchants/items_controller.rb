class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    begin
      merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    rescue StandardError => e
      error_merchant = ErrorMerchant.new(
        e.message, 
        "NOT FOUND",
        404
      )
      render json: ErrorMerchantSerializer.new(error_merchant).serialized_json, status: 404
    end
  end
end