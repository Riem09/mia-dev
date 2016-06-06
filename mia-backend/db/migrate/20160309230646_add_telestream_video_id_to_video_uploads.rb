class AddTelestreamVideoIdToVideoUploads < ActiveRecord::Migration
  def change
    add_column :video_uploads, :telestream_id, :string
    add_column :video_uploads, :h264_job_id, :string
    add_column :video_uploads, :webm_job_id, :string
    add_index :video_uploads, :telestream_id
    remove_column :video_uploads, :job_id
  end
end
