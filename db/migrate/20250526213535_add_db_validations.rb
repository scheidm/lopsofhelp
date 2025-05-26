class AddDbValidations < ActiveRecord::Migration[8.0]
  def up 
    change_column :geos, :lat, :string, null: false
    change_column :geos, :lon, :string, null: false
    add_index :geos, :greenspace_id
  end
  def down
    remove_index :geos, :greenspace_id
  end
end
