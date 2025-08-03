class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true

  def total_games_played
    stats[:games].reduce do |game|
      game.play_count
    end
  end

  def increment_game_play_count(game_name)
    return nil unless stats[:games][game_name][:play_count]
  end

  def game_play_count(game_name)
    # This line needs a lot of help, but don't want to get hung up on it right now.
    return nil unless stats && stats['games'] && stats['games'][game_name] && stats['games'][game_name]['play_count']

    stats['games'][game_name]['play_count']
  end
end
