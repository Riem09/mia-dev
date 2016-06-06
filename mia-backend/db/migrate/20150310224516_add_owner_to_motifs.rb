class AddOwnerToMotifs < ActiveRecord::Migration
  def change
    add_reference :motifs, :owner, index: true
  end
end
