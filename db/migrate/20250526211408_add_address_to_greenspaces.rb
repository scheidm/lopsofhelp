class AddAddressToGreenspaces < ActiveRecord::Migration[8.0]
  def change
    def change
      add_column :greenspaces, :address, :string
      add_column :greenspaces, :postcode, :string
    end
  end
end
