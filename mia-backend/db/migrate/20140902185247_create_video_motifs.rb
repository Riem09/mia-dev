class CreateVideoMotifs < ActiveRecord::Migration
  def change
    create_table :video_motifs do |t|
      t.references :video, :index => true
      t.references :motif, :index => true
      t.text :description
      t.integer :timestamp

      t.timestamps
    end
  end
end
