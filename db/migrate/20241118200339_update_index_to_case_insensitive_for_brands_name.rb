class UpdateIndexToCaseInsensitiveForBrandsName < ActiveRecord::Migration[8.0]
  def change
    remove_index :brands, :name
    add_index :brands, "LOWER(name)", unique: true
  end
end
