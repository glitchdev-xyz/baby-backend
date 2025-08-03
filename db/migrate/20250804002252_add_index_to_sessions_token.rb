class AddIndexToSessionsToken < ActiveRecord::Migration[8.0]
  def change
    add_index :sessions, :token
  end
end
