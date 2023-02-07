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

  it 'can get one item by its id' do 
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}"

    item_response = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_response[:data]).to have_key(:id)
    expect(item_response[:data]).to have_key(:type)
    expect(item_response[:data][:type]).to eq("item")
    expect(item_response[:data]).to have_key(:attributes)
    expect(item_response[:data][:attributes]).to have_key(:description)
    expect(item_response[:data][:attributes][:description]).to eq(item.description)
    expect(item_response[:data][:attributes]).to have_key(:unit_price)
    expect(item_response[:data][:attributes][:unit_price]).to eq(item.unit_price)
  end

  it 'returns an error response when the item id does not exist' do 

    get "/api/v1/items/1"

    item_response = JSON.parse(response.body, symbolize_names: true)

    expect(item_response[:error]).to have_key(:status)
    expect(item_response[:error][:status]).to eq("NOT FOUND")
    expect(item_response[:error]).to have_key(:message)
    expect(item_response[:error][:message]).to eq("Couldn't find Item with 'id'=1")
    expect(item_response[:error]).to have_key(:code)
    expect(item_response[:error][:code]).to eq(404)
  end
end