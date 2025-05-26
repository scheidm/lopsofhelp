class AddRegionsToCities < ActiveRecord::Migration[8.0]
  def up
    change_table :cities do |t|
      t.references :region
    end
  end
  
  def drop
    remove_column :cities, :region_id
  end
end
