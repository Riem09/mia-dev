class RemoveDeviseConfirmationSentAt < ActiveRecord::Migration
  def change
    remove_column :users, :confirmation_sent_at
  end
end
