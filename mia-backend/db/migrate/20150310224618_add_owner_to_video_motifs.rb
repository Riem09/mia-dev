class AddOwnerToVideoMotifs < ActiveRecord::Migration
  def change
    add_reference :video_motifs, :owner, index: true
  end
end
