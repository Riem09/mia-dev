class AddEndTimeMsToVideoMotifs < ActiveRecord::Migration
  def change
    add_column :video_motifs, :end_time_ms, :integer
  end
end
