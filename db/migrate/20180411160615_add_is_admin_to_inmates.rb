class AddIsAdminToInmates < ActiveRecord::Migration[5.1]
  def change
    add_column :inmates, :is_admin, :boolean, default: false
  end
end
