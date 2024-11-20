class ModelsController < ApplicationController
  # GET /models
  # Returns a list of the models depending on the parameters given
  # Returns an error message if the param greater is higher than param lower, or if the passed parameters are not integer
  def index
    models = Model.all

    # Validate params
    greater = Integer(params[:greater]) rescue nil
    lower = Integer(params[:lower]) rescue nil
    if params[:greater].present? && greater.nil? || params[:lower].present? && lower.nil?
      render json: { error: "Invalid parameters" }, status: :bad_request
      return
    end
    if greater && lower && greater > lower
      render json: { error: "greater cannot be higher than lower" }, status: :bad_request
      return
    end

    # Filter results based on params
    models = models.where("COALESCE(average_price, 0) > ?", greater) if greater
    models = models.where("COALESCE(average_price, 0) < ?", lower) if lower
    render json: ModelsRepresenter.new(models).as_json, status: :ok
  end

  # PUT /brands
  # Updates a model's average price
  # Return error message if average_price is not higher than 100,000
  def update
    model = Model.find(params[:id])
    model.update!(model_params)
    render json: { message: "Model updated successfully", id: model.id, name: model.name, average_price: model.average_price }, status: :ok
  end

  private

  def model_params
    params.require(:model).permit(:average_price)
  end
end
