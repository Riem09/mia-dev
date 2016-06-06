class CreateMotifs < ActiveRecord::Migration
  def change
    create_table :motifs do |t|
      t.string :name
      t.text :description
      t.references :parent, index: true

      t.timestamps
    end
  end
end
