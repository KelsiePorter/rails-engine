require 'rails_helper'

RSpec.describe 'Items Merchants Index API' do 
  it 'returns the merchant associated with an item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"

    item_merchant = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
    expect(response).to be_successful
    expect(item_merchant[:data]).to have_key(:id)
    expect(item_merchant[:data]).to have_key(:type)
    expect(item_merchant[:data][:type]).to eq("merchant")
    expect(item_merchant[:data]).to have_key(:attributes)
    expect(item_merchant[:data][:attributes]).to have_key(:name)
    expect(item_merchant[:data][:attributes][:name]).to eq(merchant.name)
  end

  it 'returns an error if the item is not found' do 
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{Item.last.id+1}/merchant"

    item_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(item_merchant[:error]).to have_key(:status)
    expect(item_merchant[:error][:status]).to eq("NOT FOUND")
    expect(item_merchant[:error]).to have_key(:message)
    expect(item_merchant[:error][:message]).to eq("Couldn't find Item with 'id'=#{Item.last.id+1}")
    expect(item_merchant[:error]).to have_key(:code)
    expect(item_merchant[:error][:code]).to eq(404)
  end
end