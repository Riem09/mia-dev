class RemoveParentIdFromMotifs < ActiveRecord::Migration
  def change
    remove_column :motifs, :parent_id
  end
end
