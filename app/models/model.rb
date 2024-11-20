class Model < ApplicationRecord
  belongs_to :brand

  # Updates the Brand's average price after a model is added or updated
  after_save :update_brand_average_price
  # Verifies that the average price is higher than 100,000
  validates :average_price, numericality: { greater_than: 100000 }, allow_nil: true
  validates :name, presence: true, uniqueness: { scope: :brand_id, case_sensitive: false }

  private

  def update_brand_average_price
    brand.update_average_price
  end
end
