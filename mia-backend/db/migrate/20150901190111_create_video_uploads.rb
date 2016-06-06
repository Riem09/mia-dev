class CreateVideoUploads < ActiveRecord::Migration
  def change
    create_table :video_uploads do |t|
      t.references :user, index: true

      t.string :source_video
      t.string :webm_video_url
      t.string :mp4_video_url

      t.string :status, :default => 'Submitted'
      t.string :message
      t.string :job_id

      t.timestamps
    end
  end
end
