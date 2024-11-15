require 'rails_helper'

RSpec.describe "GET /brands", type: :request do
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
