class Model < ApplicationRecord
  belongs_to :brand

  # Updates the Brand's average price after a model is added or updated
  after_save :update_brand_average_price

  private

  def update_brand_average_price
    brand.update_average_price
  end
end
