class CreateLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :links do |t|
      t.references :ownable, polymorphic: true, null: false
      t.string :kind
      t.string :url

    end
  end
end
