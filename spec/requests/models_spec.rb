require 'rails_helper'

RSpec.describe "Models", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/models/index"
      expect(response).to have_http_status(:success)
    end
  end

end
