class Api::V1::Items::SearchController < ApplicationController
  def show
    if find_by_name?
      find_by_name
    elsif find_by_price?
      find_by_price
    else
      render json: {status: 400, message: "BAD REQUEST"}, status: 400
    end
  end

  private

  def find_by_name
    item = Item.where("lower(name) like ?", "%#{sanitized_name}%")
               .order('name')
               .first
    render json: ItemSerializer.new(item)
  end

 def find_by_price
    if permitted_params[:min_price] && params[:max_price]
      items = Item.where(
                    'unit_price >= ? and unit_price <= ?', 
                    permitted_params[:min_price], 
                    permitted_params[:max_price]
                  )
                  .order('unit_price')
                  .first
    elsif permitted_params[:min_price] 
      items = Item.where('unit_price >= ?', permitted_params[:min_price])
                  .order('unit_price')
                  .first
    else
      items = Item.where('unit_price <= ?', permitted_params[:max_price])
                  .order('unit_price')
                  .last
    end
    render json: ItemSerializer.new(items)
  end

  private

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