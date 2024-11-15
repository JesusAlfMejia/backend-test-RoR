require 'rails_helper'

RSpec.describe "Brands Endpoints", type: :request do
  describe "GET /brands" do
    let!(:brand1) { FactoryBot.create(:brand, name: "Acura", average_price: 700000) }
    let!(:brand2) { FactoryBot.create(:brand, name: "Audi", average_price: 800000) }

    it "returns all brands, each with an average price" do
      get "/brands"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)
      expect(json_response[0]["name"]).to eq("Acura")
      expect(json_response[1]["average_price"].to_d).to eq(800000.0)
    end
  end

  describe "GET /brands/:id/models" do
    let!(:brand) { FactoryBot.create(:brand, name: "Acura") }

    before do
      FactoryBot.create(:model, name: "ILX", average_price: 303176, brand: brand)
      FactoryBot.create(:model, name: "MDX", average_price: 448193, brand: brand)
      FactoryBot.create(:model, name: "NSX", average_price: 3818225, brand: brand)
      FactoryBot.create(:model, name: "RDX", average_price: 395753, brand: brand)
      FactoryBot.create(:model, name: "RL", average_price: 239050, brand: brand)
    end

    it "returns 5 Acura models" do
      get "/brands/#{brand.id}/models"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(5)
      expect(json_response[1]["name"]).to eq("MDX")
      expect(json_response[2]["average_price"]).to eq(3818225)
      end
  end
end
