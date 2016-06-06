class AddOwnerToVideo < ActiveRecord::Migration
  def change
    add_reference :videos, :owner, index: true
  end
end
