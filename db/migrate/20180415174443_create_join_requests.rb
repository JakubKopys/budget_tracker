class CreateJoinRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :join_requests do |t|
      t.integer :invitee_id,   null: false
      t.datetime :expires_at,  null: false
      t.references :household, null: false, index: true, foreign_key: true
      t.string :state,         null: false
      t.string :type,          null: false

      t.timestamps null: false
    end

    add_foreign_key :join_requests, :users, column: :invitee_id
    add_index :join_requests, [:invitee_id, :household_id], unique: true
  end
end
