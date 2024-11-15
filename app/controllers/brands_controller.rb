class BrandsController < ApplicationController
  # GET /brands
  def index
    render json: Brand.all
  end
end
