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
    if params[:name].blank?
      render json: { error: "Name parameter is required" }, status: :bad_request
      return
    end
    brand = Brand.new(brand_params)
    if brand.save
      render json: { message: "Brand created successfully", id: brand.id, name: brand.name }, status: :created
    else
      render json: { error: brand.errors.full_messages }, status: :conflict
    end
  end

  # GET /brands/:id/models
  # Return all models of a brand sorted by alphabetical order
  def models_get
    brand = Brand.find_by(id: params[:id])
    if brand
      models = brand.models
      render json: ModelsRepresenter.new(models).as_json
    else
      render json: { error: "Brand not found" }, status: :not_found
    end
  end

  # POST /brands/:id/models
  # Creates a new model based on the brand, name and an optional average_price
  def models_post
    brand = Brand.find_by(id: params[:id])
    if !brand
      render json: { error: "Invalid Brand ID" }, status: :not_found
      return
    elsif params[:name].blank?
      render json: { error: "Name paramater is required" }, status: :bad_request
      return
    elsif brand.models.where("LOWER(name) = ?", params[:name].downcase).present?
      render json: { error: "Name already in use by another model of the same brand" }, status: :conflict
      return
    elsif params[:average_price].present? && params[:average_price] <= 100000
      render json: { error: "Average price must be higher than 100,000" }, status: :unprocessable_entity
      return
    end
    model = Model.new(model_params.merge(brand_id: brand.id))
    if model.save
      render json: { message: "Model created successfully", id: model.id, name: model.name }, status: :created
    else
      render json: { error: model.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end

  def model_params
    params.permit(:name, :average_price)
  end
end
