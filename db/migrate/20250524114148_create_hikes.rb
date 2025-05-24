class CreateHikes < ActiveRecord::Migration[7.2]
  def change
    create_table :hikes do |t|
      t.date :date
      t.references :greenspace, null: false, foreign_key: true
      t.integer :distance
      t.integer :waste
    end
    add_index :hikes, :date
  end
end
