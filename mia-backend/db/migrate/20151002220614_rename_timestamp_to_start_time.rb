class RenameTimestampToStartTime < ActiveRecord::Migration
  def change
    rename_column :video_motifs, :timestamp, :start_time_ms
  end
end
