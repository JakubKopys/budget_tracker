class CreateHouseholds < ActiveRecord::Migration[5.1]
  def change
    create_table :households do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
