class AddVideoUploadToVideo < ActiveRecord::Migration
  def change
    add_reference :videos, :video_upload, index: true, foreign_key: true
  end
end
