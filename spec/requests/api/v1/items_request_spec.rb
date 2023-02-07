require 'rails_helper'

describe 'Items API' do 
  it 'sends a list of all items' do 
    merchant = create(:merchant)
    3.times do 
      create(:item, merchant_id: merchant.id)
    end

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to have_key(:data)
    expect(items[:data].size).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to_not have_key(:merchant_id)
    end
  end

  it 'returns an empty array when there are no items' do 
    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to have_key(:data)
    expect(items[:data].size).to eq(0)
  end
end