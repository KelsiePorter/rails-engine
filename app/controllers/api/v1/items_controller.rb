class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    begin
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item)
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