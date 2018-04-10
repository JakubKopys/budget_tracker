class CreateInmates < ActiveRecord::Migration[5.1]
  def change
    create_table :inmates do |t|
      t.belongs_to :user,      index: true, foreign_key: true, null: false
      t.belongs_to :household, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_index :inmates, [:user_id, :household_id], unique: true
  end
end
