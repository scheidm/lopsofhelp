class CreateGreenspaces < ActiveRecord::Migration[7.2]
  def change
    create_table :greenspaces do |t|
      t.string :name
      t.references :city
      t.references :address, index: true, foreign_key: {to_table: :geos}
      t.string :slug, null: false
    end
    add_index :greenspaces, :name
    add_index :greenspaces, :slug

  end
end
