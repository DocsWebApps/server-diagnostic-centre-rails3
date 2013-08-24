class AddIndexServerMetricDate < ActiveRecord::Migration
  def up
      add_index :server_metrics, :date
  end
end
