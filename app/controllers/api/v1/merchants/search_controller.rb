class Api::V1::Merchants::SearchController < ApplicationController
  def index
    if permitted_params[:name]
      find_by_name
    else
      render json: {status: 400, message: "BAD REQUEST"}, status: 400
    end
  end

  private

  def find_by_name
    merchant = Merchant.where("lower(name) like ?", "%#{sanitized_name}%")
                        .order('name')
    render json: MerchantSerializer.new(merchant)
  end

  def permitted_params
    params.permit(:name)
  end

  def sanitized_name
    permitted_params[:name].downcase
  end
end