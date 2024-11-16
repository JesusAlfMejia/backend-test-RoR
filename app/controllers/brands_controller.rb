class BrandsController < ApplicationController
  # GET /brands
  # Return all brands
  def index
    render json: Brand.all
  end

  # GET /brands/:id/models
  # Return all models of a brand sorted by alphabetical order
  def models
    brand = Brand.find_by(id: params[:id])
    if brand
      models = brand.models
      render json: ModelsRepresenter.new(models).as_json
    else
      render json: { error: "Brand not found" }, status: :not_found
    end
  end
end
