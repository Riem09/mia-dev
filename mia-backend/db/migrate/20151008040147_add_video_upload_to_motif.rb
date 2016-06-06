class AddVideoUploadToMotif < ActiveRecord::Migration
  def change
    add_reference :motifs, :video_upload, index: true, foreign_key: true
  end
end
