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

  def create
    item = Item.new(item_params)

    if item.save
      render json: ItemSerializer.new(item)
    else
      error_item = ErrorItem.new(
        item.errors.full_messages.to_sentence,
        "BAD REQUEST",
        400
      )
      render json: ErrorItemSerializer.new(error_item).serialized_json
    end
  end

  def update
    begin
      item = Item.find(params[:id])

      if item.update(item_params)
        render json: ItemSerializer.new(item)
      else
        error_item = ErrorItem.new(
          item.errors.full_messages.to_sentence,
          "BAD REQUEST",
          400
        )
        render json: ErrorItemSerializer.new(error_item).serialized_json
      end
    rescue StandardError => e
      error_item = ErrorItem.new(
        e.message, 
        "NOT FOUND",
        404
      )
      render json: ErrorItemSerializer.new(error_item).serialized_json
    end
  end

  def destroy
    begin
      Item.destroy(params[:id])
    rescue StandardError => e
      error_item = ErrorItem.new(
        e.message, 
        "NOT FOUND",
        404
      )
      render json: ErrorItemSerializer.new(error_item).serialized_json
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end