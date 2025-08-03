class AddOccurredAtToGameEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :game_events, :occurred_at, :string
  end
end
