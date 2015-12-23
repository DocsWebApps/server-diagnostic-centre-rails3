class AddIndexOnProcessMetricsTimeServerid < ActiveRecord::Migration
  def up
    add_index :process_metrics,[:time,:server_id]
  end

  def down
    drop_index
  end
end
