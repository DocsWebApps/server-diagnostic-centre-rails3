class CreateServerMetrics < ActiveRecord::Migration
  def change
    create_table :server_metrics do |t|
      t.date :date
      t.datetime :time
      t.decimal :cpu
      t.decimal :mem
      t.decimal :net_in
      t.decimal :net_out
      t.decimal :disk
      t.references :server

      t.timestamps
    end
    add_index :server_metrics, :server_id
  end
end
