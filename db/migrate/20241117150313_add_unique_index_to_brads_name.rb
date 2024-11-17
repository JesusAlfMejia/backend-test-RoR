class AddUniqueIndexToBradsName < ActiveRecord::Migration[8.0]
  def change
    add_index :brands, :name, unique: true
  end
end
