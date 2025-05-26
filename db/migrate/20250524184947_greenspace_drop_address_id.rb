class GreenspaceDropAddressId < ActiveRecord::Migration[8.0]
  def change
    remove_column :greenspaces, :address_id
  end
end
