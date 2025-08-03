class AddStatsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :stats, :json
  end
end
