class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.string :name, null: false
      t.string :slug, null: false
    end
    add_index :pages, :name
    add_index :pages, :slug

  end
end
