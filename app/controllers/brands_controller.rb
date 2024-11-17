class BrandsController < ApplicationController
  # GET /brands
  # Return all brands
  def index
    brands = Brand.all
    render json: BrandsRepresenter.new(brands).as_json
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

  # POST /brands
  # Creates a new brand by passing the name of the brand
  # Return error message if a brand with the passed name already exists
  def create
    brand = Brand.new(brand_params)
    if brand.save
      render json: { message: "Brand created successfully", id: brand.id, name: brand.name }, status: :created
    else
      render json: { error: brand.errors.full_messages }, status: :conflict
    end
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end
end
