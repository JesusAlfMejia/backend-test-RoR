class Brand < ApplicationRecord
  has_many :models
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def update_average_price
    self.average_price = models.where("average_price IS NOT NULL").average(:average_price).to_i
    save!
  end
end
