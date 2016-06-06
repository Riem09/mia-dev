class CreateRelatedMotifs < ActiveRecord::Migration
  def change
    create_table :related_motifs do |t|
      t.references :motif1, :index => true
      t.references :motif2, :index => true

      t.timestamps :null => false
    end
  end
end
