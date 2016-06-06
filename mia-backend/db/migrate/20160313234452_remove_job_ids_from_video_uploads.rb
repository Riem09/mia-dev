class RemoveJobIdsFromVideoUploads < ActiveRecord::Migration
  def change
    remove_column :video_uploads, :source_video
    remove_column :video_uploads, :h264_job_id
    remove_column :video_uploads, :webm_job_id
  end
end
