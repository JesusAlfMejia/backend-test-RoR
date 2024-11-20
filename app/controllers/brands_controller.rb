class BrandsController < ApplicationController
  # GET /brands
  # Return all brands
  def index
    brands = Brand.all
    render json: BrandsRepresenter.new(brands).as_json
  end

  # POST /brands
  # Creates a new brand by passing the name of the brand
  # Return error message if a brand with the passed name already exists
  def create
    brand = Brand.create!(brand_params)
    render json: { message: "Brand created successfully", id: brand.id, name: brand.name }, status: :created
  end

  # GET /brands/:id/models
  # Return all models of a brand sorted by alphabetical order
  def models_get
    brand = Brand.find(params[:id])
    models = brand.models
    render json: ModelsRepresenter.new(models).as_json
  end

  # POST /brands/:id/models
  # Creates a new model based on the brand, name and an optional average_price
  def models_post
    brand = Brand.find(params[:id])
    model = brand.models.create!(model_params)
    render json: { message: "Model created successfully", id: model.id, name: model.name }, status: :created
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end

  def model_params
    params.permit(:name, :average_price)
  end
end
