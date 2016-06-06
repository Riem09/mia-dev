class AddThumbnailsToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :thumbnail_default, :string
    add_column :videos, :thumbnail_medium, :string
    add_column :videos, :thumbnail_high, :string
  end
end
