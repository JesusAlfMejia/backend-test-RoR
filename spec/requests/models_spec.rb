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
end
