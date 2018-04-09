class CreateExpiredTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :expired_tokens do |t|
      t.string :token,        null: false
      t.datetime :expires_at, null: false
    end

    add_index :expired_tokens, :token, unique: true
  end
end
