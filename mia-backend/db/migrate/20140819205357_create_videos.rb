class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.text :credits
      t.string :external_id
      t.string :type
      t.string :external_url
      t.boolean :published, :default => false
      t.integer :duration

      t.timestamps
    end
  end
end
