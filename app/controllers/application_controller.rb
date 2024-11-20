class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  private

  def handle_parameter_missing(exception)
    render json: { error: "Parameter is missing or the value is empty or invalid" }, status: :bad_request
  end

  def handle_record_invalid(exception)
    if exception.message.include? "taken"
      render json: { error: exception.message }, status: :conflict
    else
      render json: { error: exception.message }, status: :unprocessable_entity
    end
  end

  def handle_record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
