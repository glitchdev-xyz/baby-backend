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
    # TODO - non happy path cases.
    # It works only if the name name exists, for now.
    return nil unless stats && stats['games']

    count = stats['games'][game_name]['play_count'].to_int
    stats['games'][game_name]['play_count'] = count + 1
    save!
  end

  def game_play_count(game_name)
    # TODO: Figure out a nice way to deal with this field
    # I know this line is very silly.
    return nil unless stats && stats['games'] && stats['games'][game_name] && stats['games'][game_name]['play_count']

    stats['games'][game_name]['play_count']
  end
end
