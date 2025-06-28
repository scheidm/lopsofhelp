class EnforceUniqueGeos < ActiveRecord::Migration[8.0]
  def change
    add_index :geos, [:lat, :lon], unique: true
  end
end
