require 'rails_helper'

RSpec.describe "Brands Endpoints", type: :request do
  describe "GET /brands" do
    before do
      FactoryBot.create(:brand, name: "Acura", average_price: 700000)
      FactoryBot.create(:brand, name: "Audi", average_price: 800000)
    end

    it "returns all brands, each with an average price" do
      get "/brands"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)
      expect(json_response[0]["name"]).to eq("Acura")
      expect(json_response[1]["average_price"]).to eq(800000)
    end
  end

  describe "GET /brands/:id/models" do
    let!(:brand) { FactoryBot.create(:brand, name: "Acura") }

    before do
      FactoryBot.create(:model, name: "RL", average_price: 239050, brand: brand)
      FactoryBot.create(:model, name: "MDX", average_price: 448193, brand: brand)
      FactoryBot.create(:model, name: "RDX", average_price: 395753, brand: brand)
      FactoryBot.create(:model, name: "ILX", average_price: 303176, brand: brand)
      FactoryBot.create(:model, name: "NSX", average_price: 3818225, brand: brand)
    end

    it "returns 5 Acura models" do
      get "/brands/#{brand.id}/models"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(5)
      expect(json_response[0]["name"]).to eq("ILX")
      expect(json_response[2]["average_price"]).to eq(3818225)
      end
  end

  describe "POST /brands" do
    it "creates a new brand" do
      expect {
        post "/brands", params: { name: "Toyota"  }, as: :json
      }.to change { Brand.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Brand created successfully")
      expect(Brand.find_by(name: "Toyota").average_price).to be_nil
    end

    it "returns an error if the brand already exists" do
      FactoryBot.create(:brand, name: "Toyota")
      expect {
        post "/brands", params: { name: "Toyota"  }, as: :json
      }.not_to change { Brand.count }

      expect(response).to have_http_status(:conflict)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to include("Name has already been taken")
    end
  end

  describe "POST /brands/:id/models" do
    let!(:brand) { FactoryBot.create(:brand, name: "Toyota") }

    it "creates a new model" do
      expect {
        post "/brands/#{brand.id}/models", params: { name: "Prius", average_price: 406400 }, as: :json
      }.to change { Model.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Model created successfully")
      expect(Brand.find_by(name: "Toyota").average_price).to eq(406400)
    end

    it "creates a new model without an average price" do
      FactoryBot.create(:model, name: "Avanza", average_price: 160000, brand_id: brand.id)
      FactoryBot.create(:model, name: "Camry", average_price: 260000, brand_id: brand.id)
      expect {
        post "/brands/#{brand.id}/models", params: { name: "Prius" }, as: :json
      }.to change { Model.count }.from(2).to(3)

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]).to eq("Model created successfully")
      expect(Model.last.average_price).to be_nil
      expect(Brand.find_by(name: "Toyota").average_price).to eq(210000)
    end

    it "throws an error if brand id is invalid" do
      expect {
        post "/brands/#{brand.id + 1}/models", params: { name: "Prius", average_price: 406400 }, as: :json
      }.not_to change { Model.count }

      expect(response).to have_http_status(:not_found)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to include("Couldn't find Brand")
    end

    it "throws an error if a model of the same brand already exists" do
      FactoryBot.create(:model, name: "Prius", average_price: 406400, brand_id: brand.id)

      expect {
        post "/brands/#{brand.id}/models", params: { name: "Prius", average_price: 406400 }, as: :json
      }.not_to change { Model.count }

      expect(response).to have_http_status(:conflict)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to include("Name has already been taken")
    end

    it "throws an error if the given average price is not higher than 100,000" do
      expect {
        post "/brands/#{brand.id}/models", params: { name: "Prius", average_price: 1000 }, as: :json
      }.not_to change { Model.count }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to include("Average price must be greater than 100000")
    end
  end
end
