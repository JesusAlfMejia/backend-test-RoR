class ChangeAveragePriceToIntegerInBrands < ActiveRecord::Migration[8.0]
  def change
    change_column :brands, :average_price, :integer
  end
end
