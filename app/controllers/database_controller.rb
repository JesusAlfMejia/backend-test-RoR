class DatabaseController < ApplicationController
  def reset
    begin
      # Destroy tables
      Model.destroy_all
      Brand.destroy_all

      # Reset IDs
      ActiveRecord::Base.connection.reset_pk_sequence!("brands")
      ActiveRecord::Base.connection.reset_pk_sequence!("models")

      # Seed json file
      seed_data

      render json: { message: "Database reset successfully" }, status: :ok
    # Catch any possible errors
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def seed_data
    # Read models.json file
    file_path = Rails.root.join("db", "models.json")
    json_data = JSON.parse(File.read(file_path))

    # Create brands and models
    json_data.each do |model|
      brand = Brand.find_by(name: model["brand_name"]) || Brand.create!(name: model["brand_name"])
      model = Model.new(
        id: model["id"],
        name: model["name"],
        average_price: model["average_price"],
        brand_id: brand.id
      )
      model.save(validate: false)
    end

    # Reset PostgreSQL sequence
    ActiveRecord::Base.connection.reset_pk_sequence!("models")
  end
end
