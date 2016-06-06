class AddFieldsToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :transcript, :text
    add_column :videos, :director, :string
    add_column :videos, :production, :string
    add_column :videos, :fx, :string
    add_column :videos, :client, :string
    add_column :videos, :industry, :string
    add_column :videos, :year, :string
    add_column :videos, :location, :string
    remove_column :videos, :credits
  end
end
