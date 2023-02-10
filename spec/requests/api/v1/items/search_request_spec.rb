require 'rails_helper'

RSpec.describe 'Item Search API' do 
  describe 'find one item' do
    it 'can find the first alphabetical item based on name search criteria' do 
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, name: 'Silver Ring', description: 'round and silver')
      item2 = create(:item, merchant_id: merchant.id, name: 'Dog Toy', description: 'fun for dogs')
      item3 = create(:item, merchant_id: merchant.id, name: 'Gold Rings', description: 'round and gold')

      search = "ring"

      get "/api/v1/items/find?name=#{search}"

      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(search_result[:data]).to have_key(:id)
      expect(search_result[:data][:attributes][:name]).to eq(item3.name)
      expect(search_result[:data][:attributes][:description]).to eq(item3.description)
    end

    it 'can find the first alphabetical item based on minimum price search criteria' do 
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, name: 'Silver Ring', description: 'round and silver', unit_price: 10.99)
      item2 = create(:item, merchant_id: merchant.id, name: 'Dog Toy', description: 'fun for dogs', unit_price: 5.75)
      item3 = create(:item, merchant_id: merchant.id, name: 'Gold Rings', description: 'round and gold', unit_price: 3.50)

      search = 4.99

      get "/api/v1/items/find?min_price=#{search}"

      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(search_result[:data]).to have_key(:id)
      expect(search_result[:data][:attributes][:name]).to eq(item2.name)
      expect(search_result[:data][:attributes][:description]).to eq(item2.description)
    end

    it 'can find the first alphabetical item based on maximum price search criteria' do 
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, name: 'Silver Ring', description: 'round and silver', unit_price: 10.99)
      item2 = create(:item, merchant_id: merchant.id, name: 'Dog Toy', description: 'fun for dogs', unit_price: 5.75)
      item3 = create(:item, merchant_id: merchant.id, name: 'Gold Rings', description: 'round and gold', unit_price: 3.50)

      search = 99.99

      get "/api/v1/items/find?max_price=#{search}"

      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(search_result[:data]).to have_key(:id)
      expect(search_result[:data][:attributes][:name]).to eq(item1.name)
      expect(search_result[:data][:attributes][:description]).to eq(item1.description)
    end

    it 'can find the first alphabetical item based on minimum and maximum price search criteria' do 
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, name: 'Silver Ring', description: 'round and silver', unit_price: 10.99)
      item2 = create(:item, merchant_id: merchant.id, name: 'Dog Toy', description: 'fun for dogs', unit_price: 5.75)
      item3 = create(:item, merchant_id: merchant.id, name: 'Gold Rings', description: 'round and gold', unit_price: 3.50)

      min_price = 2.99
      max_price = 99.99

      get "/api/v1/items/find?max_price=#{max_price}&min_price=#{min_price}"

      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(search_result[:data]).to have_key(:id)
      expect(search_result[:data][:attributes][:name]).to eq(item3.name)
      expect(search_result[:data][:attributes][:description]).to eq(item3.description)
    end

    it 'user receives an error if using incorrect parameters' do 
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id, name: 'Silver Ring', description: 'round and silver', unit_price: 10.99)
      item2 = create(:item, merchant_id: merchant.id, name: 'Dog Toy', description: 'fun for dogs', unit_price: 5.75)
      item3 = create(:item, merchant_id: merchant.id, name: 'Gold Rings', description: 'round and gold', unit_price: 3.50)

      name = 'ring'
      min_price = 2.99
      max_price = 99.99

      get "/api/v1/items/find?name=#{name}&max_price=#{max_price}&min_price=#{min_price}"

      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(response.message).to eq("Bad Request")
    end
  end
end