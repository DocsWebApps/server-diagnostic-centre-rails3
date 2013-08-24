class CreateProcessMetrics < ActiveRecord::Migration
  def change
    create_table :process_metrics do |t|
      t.date :date
      t.datetime :time
      t.integer :proc_id
      t.string :proc_name
      t.string :proc_owner
      t.decimal :cpu
      t.decimal :mem
      t.integer :threads
      t.decimal :disk
      t.references :server

      t.timestamps
    end
    add_index :process_metrics, :server_id
  end
end
