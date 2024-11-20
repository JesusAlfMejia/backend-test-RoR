# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'json'

# Read models.json file
file_path = Rails.root.join('db', 'models.json')
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
ActiveRecord::Base.connection.reset_pk_sequence!('models')
