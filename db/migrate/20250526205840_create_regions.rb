class CreateRegions < ActiveRecord::Migration[8.0]
  def change
    create_table :regions do |t|
      t.string :name
      t.string :slug
    end
    add_index :regions, :name
    add_index :regions, :slug
  end
end
