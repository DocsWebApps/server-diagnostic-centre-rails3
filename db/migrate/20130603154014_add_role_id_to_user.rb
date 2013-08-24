class AddRoleIdToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.references :role
    end
  end
end
