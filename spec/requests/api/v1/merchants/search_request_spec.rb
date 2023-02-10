require 'rails_helper'

RSpec.describe 'Merchant Search API' do 
  describe 'find all merchants' do 
    it 'can find all merchants based on name search criteria in alphabetical order' do 
      merchant1 = create(:merchant, name: "Turing")
      merchant2 = create(:merchant, name: "Ring World")
      merchant3 = create(:merchant, name: "Bring It")
      merchant4 = create(:merchant, name: "Dog World")

      search = "ring"

      get "/api/v1/merchants/find_all?name=#{search}"

      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(search_result[:data]).to be_an(Array)
      expect(search_result[:data].size).to eq(3)
      expect(search_result[:data][0][:attributes][:name]).to eq(merchant3.name)
      expect(search_result[:data][1][:attributes][:name]).to eq(merchant2.name)
      expect(search_result[:data][2][:attributes][:name]).to eq(merchant1.name)
    end

    it 'can return an empty array if no merchants meet search criteria' do 
      merchant1 = create(:merchant, name: "Turing")
      merchant2 = create(:merchant, name: "Ring World")
      merchant3 = create(:merchant, name: "Bring It")
      merchant4 = create(:merchant, name: "Dog World")

      search = "zoo"

      get "/api/v1/merchants/find_all?name=#{search}"

      search_result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(search_result[:data]).to be_an(Array)
      expect(search_result[:data].size).to eq(0)
      expect(search_result[:data]).to eq([])
    end
  end
end