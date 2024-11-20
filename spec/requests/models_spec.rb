require 'rails_helper'

RSpec.describe "Models", type: :request do
  describe "PUT /models/:id" do
    let!(:brand) { FactoryBot.create(:brand, name: "Acura") }
    let!(:model1) { FactoryBot.create(:model, name: "ILX", average_price: 200000, brand_id: brand.id) }
    let!(:model2) { FactoryBot.create(:model, name: "MDX", average_price: 350000, brand_id: brand.id) }

    it "updates a model's average price" do
      brand.reload
      expect {
        put "/models/#{model1.id}", params: { average_price: 500000 }, as: :json
        brand.reload
        model1.reload
      }.to change { model1.average_price }.from(200000).to(500000)
      .and change { brand.average_price }.from(275000).to(425000)

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Model updated successfully")
      expect(json_response["id"]).to eq(model1.id)
      expect(json_response["name"]).to eq("ILX")
    end

    it "throws an error if average_price is not higher than 100,000" do
      expect {
        put "/models/#{model1.id}", params: { average_price: 1000 }, as: :json
        model1.reload
      }.not_to change { model1.average_price }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to include("Average price must be greater than 100000")
    end
  end

  describe "GET /models" do
    before do
      brand1 = FactoryBot.create(:brand, name: "Acura")
      brand2 = FactoryBot.create(:brand, name: "Toyota")
      FactoryBot.create(:model, name: "ILX", average_price: "300000", brand_id: brand1.id)
      FactoryBot.create(:model, name: "MDX", average_price: "400000", brand_id: brand1.id)
      FactoryBot.create(:model, name: "RDX", average_price: "390000", brand_id: brand1.id)
      FactoryBot.create(:model, name: "RLX", average_price: "450000", brand_id: brand1.id)
      FactoryBot.create(:model, name: "TL", brand_id: brand1.id)
      FactoryBot.create(:model, name: "Avanza", average_price: "160000", brand_id: brand2.id)
      FactoryBot.create(:model, name: "Camry", average_price: "260000", brand_id: brand2.id)
      FactoryBot.create(:model, name: "Corolla", average_price: "180000", brand_id: brand2.id)
      FactoryBot.create(:model, name: "FJ Cruiser", brand_id: brand2.id)
      FactoryBot.create(:model, name: "Hiace", brand_id: brand2.id)
    end

    it "shows all the models" do
      get "/models"
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(10)
      expect(json_response[0]["name"]).to eq("Avanza")
      expect(json_response[9]["name"]).to eq("TL")
      expect(json_response[9]["average_price"]).to eq(0)
    end

    it "shows models within a range" do
      get "/models?greater=380000&lower=400000"
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(1)
      expect(json_response[0]["name"]).to eq("RDX")
      expect(json_response[0]["average_price"]).to eq(390000)
    end

    it "shows models higher than parameter given" do
      get "/models?greater=250000"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(5)
      expect(json_response[0]["name"]).to eq("Camry")
      expect(json_response[4]["name"]).to eq("RLX")
    end

    it "shows models lower than parameter given" do
      get "/models?lower=260000"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(5)
      expect(json_response[0]["name"]).to eq("Avanza")
      expect(json_response[4]["average_price"]).to eq(0)
    end
  end
end
