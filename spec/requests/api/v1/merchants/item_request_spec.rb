require 'rails_helper'

RSpec.describe 'Merchant Items Index API' do 
  it 'returns all items associated with a merchant' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    3.times do 
      create(:item, merchant_id: merchant1.id)
    end
    item4 = create(:item, merchant_id: merchant2.id)

    get "/api/v1/merchants/#{merchant1.id}/items"

    merchant_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant_items).to have_key(:data)
    expect(merchant_items[:data].size).to eq(3)

    merchant_items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      # expect(item[:attributes]).to_not have_key(:merchant_id)
    end
  end

  it 'returns an error if the merchant is not found' do 
    merchant = create(:merchant)

    get "/api/v1/merchants/#{Merchant.last.id+1}/items"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:errors][0]).to have_key(:status)
    expect(merchant[:errors][0][:status]).to eq("NOT FOUND")
    expect(merchant[:errors][0]).to have_key(:message)
    expect(merchant[:errors][0][:message]).to eq("Couldn't find Merchant with 'id'=#{Merchant.last.id+1}")
    expect(merchant[:errors][0]).to have_key(:code)
    expect(merchant[:errors][0][:code]).to eq(404)
  end
end