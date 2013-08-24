class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :host_name

      t.timestamps
    end
  end
end
