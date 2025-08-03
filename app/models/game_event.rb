class GameEvent < ApplicationRecord
  belongs_to :user
  validates :event_type, presence: true, inclusion: { in: %w(COMPLETED) }
  validates :game_name, presence: true
end
