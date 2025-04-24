class CreateGreenspaces < ActiveRecord::Migration[7.2]
  def change
    create_table :greenspaces do |t|
      t.string :name

    end
    add_index :greenspaces, :name
  end
end
