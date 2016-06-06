class AddDurationMsToVideoUpload < ActiveRecord::Migration
  def change
    add_column :video_uploads, :duration_ms, :integer
  end
end
