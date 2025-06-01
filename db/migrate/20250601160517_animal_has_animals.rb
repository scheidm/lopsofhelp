class AnimalHasAnimals < ActiveRecord::Migration[8.0]
  def change
    remove_column :animals, :weight_female
    remove_column :animals, :name_female
    add_reference :animals, :animal, index: true
  end
end
