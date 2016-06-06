class CreateTranscodeJobs < ActiveRecord::Migration
  def change
    create_table :transcode_jobs do |t|

      t.timestamps null: false
      t.integer :video_upload_id, null: false
      t.string :telestream_job_id, null: false
      t.integer :progress, null: false, default: 0
      t.string :profile, null: false

    end
  end
end
