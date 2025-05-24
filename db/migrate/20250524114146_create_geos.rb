class CreateGeos < ActiveRecord::Migration[7.2]
  def change
    create_table :geos do |t|
      t.integer :lat
      t.integer :long
      t.string :street_address
    end
    add_index :geos, :street_address
  end
end
