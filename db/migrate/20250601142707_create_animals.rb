class CreateAnimals < ActiveRecord::Migration[8.0]
  def change
    create_table :animals do |t|
      t.string :name, null: false
      t.integer :weight, null: false
      t.integer :weight_female
      t.string :name_female
    end
  end
end
