class RenameVideoDurationToDurationMs < ActiveRecord::Migration
  def change
    rename_column :videos, :duration, :duration_ms
  end
end
