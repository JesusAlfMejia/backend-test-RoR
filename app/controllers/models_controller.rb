class ModelsController < ApplicationController
  def index
  end

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
