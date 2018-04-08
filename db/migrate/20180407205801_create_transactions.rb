class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :type,           null: false
      t.string :title,          null: false
      t.text :description
      t.decimal :amount,        null: false, precision: 12, scale: 2
      t.belongs_to :user,       null: false, index: true, foreign_key: true
      t.belongs_to :household,  null: false, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
