class AddSubscriptionStatusToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :subscription_status, :string
  end
end
