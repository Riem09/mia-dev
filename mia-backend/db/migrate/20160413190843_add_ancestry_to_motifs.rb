class AddAncestryToMotifs < ActiveRecord::Migration
  def change
    add_column :motifs, :ancestry, :string
    add_index :motifs, :ancestry

    Motif.all.each do |motif|
      if motif.attributes["parent_id"]
        motif.parent = Motif.find(motif.attributes["parent_id"])
        motif.save!
      end
    end

  end
end
