class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    begin
      merchant = Merchant.find(params[:id])
      render json: MerchantSerializer.new(merchant)
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