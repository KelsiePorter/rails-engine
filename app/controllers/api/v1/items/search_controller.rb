class Api::V1::Items::SearchController < ApplicationController
  def show
    if find_by_name?
      find_by_name
    elsif find_by_price?
      price_less_than_zero? ? render_bad_request : find_by_price
      # if price_less_than_zero? 
      #   render_bad_request
      # else
      #   find_by_price
      # end
    else
      render_bad_request
    end
  end

  private

  def find_by_name
    item = Item.where("lower(name) like ?", "%#{sanitized_name}%")
               .order('name')
               .first
 
    if item 
      render json: ItemSerializer.new(item)
    else 
      render_empty_data
    end
  end

 def find_by_price
    if permitted_params[:min_price] && params[:max_price]
      item = Item.where(
                    'unit_price >= ? and unit_price <= ?', 
                    permitted_params[:min_price], 
                    permitted_params[:max_price]
                  )
                  .order('unit_price')
                  .first
    elsif permitted_params[:min_price] 
      item = Item.where('unit_price >= ?', permitted_params[:min_price])
                  .order('unit_price')
                  .first
 
    else
      item = Item.where('unit_price <= ?', permitted_params[:max_price])
                  .order('unit_price')
                  .last
    end

    if item 
      render json: ItemSerializer.new(item)
    else
      render_empty_data
    end 
  end

  private
  

  def render_empty_data
    render json: {status: 200, data: {}}
  end

  def render_bad_request
    render json: {status: 400, message: "BAD REQUEST", errors: []}, status: 400
  end

  def price_less_than_zero?
    permitted_params[:min_price].to_i < 0 || permitted_params[:max_price].to_i < 0 
  end

  def find_by_name?
    permitted_params[:name] && 
      !permitted_params[:min_price] && 
      !permitted_params[:max_price]
  end

  def find_by_price?
    (permitted_params[:min_price] || 
      permitted_params[:max_price]) && 
      !permitted_params[:name]
  end

  def sanitized_name
    permitted_params[:name].downcase
  end

  def permitted_params
    params.permit(:name, :min_price, :max_price)
  end
end