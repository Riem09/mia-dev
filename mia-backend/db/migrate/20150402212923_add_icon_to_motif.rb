class AddIconToMotif < ActiveRecord::Migration
  def change
    add_column :motifs, :icon, :string
  end
end
