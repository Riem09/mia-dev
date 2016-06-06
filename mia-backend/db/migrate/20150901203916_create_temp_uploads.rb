class CreateTempUploads < ActiveRecord::Migration
  def change
    create_table :temp_uploads do |t|
      t.string :upload

      t.timestamps :null => false
    end
  end
end
