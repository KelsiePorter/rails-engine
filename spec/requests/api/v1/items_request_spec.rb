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

  it 'can create a new item' do 
    merchant = create(:merchant)
    item_params = (
      {
        "name": "value1",
        "description": "value2",
        "unit_price": 100.99,
        "merchant_id": merchant.id
      }
    )
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'returns and error when an attribute is missing' do 
    merchant = create(:merchant)
    item_params = (
      {
      "name": "value1",
      "description": "value2",
      "unit_price": '',
      "merchant_id": merchant.id
      }
    )
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
    item_response = JSON.parse(response.body, symbolize_names: true)

    expect(item_response[:error]).to have_key(:status)
    expect(item_response[:error][:status]).to eq("BAD REQUEST")
    expect(item_response[:error]).to have_key(:message)
    expect(item_response[:error][:message]).to eq("Unit price can't be blank and Unit price is not a number")
    expect(item_response[:error]).to have_key(:code)
    expect(item_response[:error][:code]).to eq(400)
  end

  it 'ignores attributes from the user which are not allowed' do 
    merchant = create(:merchant)
    item_params = (
      {
        "name": "value1",
        "description": "value2",
        "unit_price": 100.99,
        "merchant_id": merchant.id,
        "number_sold": 14
      }
    )
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
    item_response = JSON.parse(response.body, symbolize_names: true)


    expect(response).to be_successful
    expect(item_response[:data][:attributes]).to_not have_key(:number_sold)
  end

  it 'can update an exisiting item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    item_params = (
      {
      "name": "Dog toy",
      "description": "dog can play with it",
      "unit_price": 10.99,
      "merchant_id": merchant.id
      }
    )
    headers = {"CONTENT_TYPE" => "application/json"}
    
    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)
    updated_item = Item.find_by(id: item.id)

    expect(response).to be_successful
    expect(updated_item.name).to_not eq(item.name)
    expect(updated_item.name).to eq(item_params[:name])
  end

  it 'returns and error when the item was not updated due to missing/incorrect attribute' do 
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    item_params = (
      {
      "name": "Dog toy",
      "description": "dog can play with it",
      "unit_price": "ten dollars",
      "merchant_id": merchant.id
      }
    )
    headers = {"CONTENT_TYPE" => "application/json"}
    
    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)
    item_response = JSON.parse(response.body, symbolize_names: true)

    expect(item_response[:error]).to have_key(:status)
    expect(item_response[:error][:status]).to eq("BAD REQUEST")
    expect(item_response[:error]).to have_key(:message)
    expect(item_response[:error][:message]).to eq("Unit price is not a number")
    expect(item_response[:error]).to have_key(:code)
    expect(item_response[:error][:code]).to eq(400)
  end

  it 'returns an error when trying to update an item that doesnt exist' do 
    merchant = create(:merchant)
    item_params = (
      {
      "name": "Dog toy",
      "description": "dog can play with it",
      "unit_price": "ten dollars",
      "merchant_id": merchant.id
      }
    )
    headers = {"CONTENT_TYPE" => "application/json"}
    
    patch "/api/v1/items/150", headers: headers, params: JSON.generate(item: item_params)


    item_response = JSON.parse(response.body, symbolize_names: true)

    expect(item_response[:error]).to have_key(:status)
    expect(item_response[:error][:status]).to eq("NOT FOUND")
    expect(item_response[:error]).to have_key(:message)
    expect(item_response[:error][:message]).to eq("Couldn't find Item with 'id'=150")
    expect(item_response[:error]).to have_key(:code)
    expect(item_response[:error][:code]).to eq(404)
  end

  it 'can destroy an item' do 
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
  end
end