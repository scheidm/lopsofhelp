class DropAddressFromGeo < ActiveRecord::Migration[8.0]
  def change
    remove_column :geos, :street_address
  end
end
