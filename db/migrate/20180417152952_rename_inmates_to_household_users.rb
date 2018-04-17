class RenameInmatesToHouseholdUsers < ActiveRecord::Migration[5.1]
  def change
    rename_table :inmates, :household_users
  end
end
