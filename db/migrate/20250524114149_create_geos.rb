class CreateGeos < ActiveRecord::Migration[7.2]
  def change
    create_table :geos do |t|
      t.string :lat
      t.string :lon
      t.string :street_address
      t.references :greenspace
    end
    add_index :geos, :street_address
  end
end
