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

    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)
      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)
      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_an(Integer)
      expect(item[:merchant_id]).to eq(merchant.id)
    end
  end
end