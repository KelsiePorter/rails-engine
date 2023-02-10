require 'rails_helper'

RSpec.describe 'Merchants API' do 
  it 'sends a list of all merchants' do 
    3.times do 
      create(:merchant)
    end

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to have_key(:data)
    expect(merchants[:data].size).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to have_key(:name)
    end
  end

  it 'returns an empty array when there are no merchants' do 
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to have_key(:data)
    expect(merchants[:data].size).to eq(0)
  end

  it 'can get one merchant by its id' do 
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    merchant_response = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchant_response[:data]).to have_key(:id)
    expect(merchant_response[:data]).to have_key(:type)
    expect(merchant_response[:data][:type]).to eq("merchant")
    expect(merchant_response[:data]).to have_key(:attributes)
    expect(merchant_response[:data][:attributes]).to have_key(:name)
    expect(merchant_response[:data][:attributes][:name]).to eq(merchant.name)
  end

  it 'returns an error response when the merchant id does not exist' do 
    merchant = create(:merchant)

    get "/api/v1/merchants/#{Merchant.last.id+1}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(merchant[:errors][0]).to have_key(:status)
    expect(merchant[:errors][0][:status]).to eq("NOT FOUND")
    expect(merchant[:errors][0]).to have_key(:message)
    expect(merchant[:errors][0][:message]).to eq("Couldn't find Merchant with 'id'=#{Merchant.last.id+1}")
    expect(merchant[:errors][0]).to have_key(:code)
    expect(merchant[:errors][0][:code]).to eq(404)
  end
end