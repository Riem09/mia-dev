class AddImageToMotif < ActiveRecord::Migration
  def change
    add_column :motifs, :image, :string
  end
end
