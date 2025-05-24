class CreateCities < ActiveRecord::Migration[7.2]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :slug, null: false
    end
    add_index :cities, :name
    add_index :cities, :slug
  end
end
