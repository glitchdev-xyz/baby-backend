require 'rails_helper'

describe User do
  describe 'validations' do
    it 'requires a password' do
      user = User.new
      user.validate

      expect(user.errors.full_messages).to include("Password can't be blank")
    end

    it 'requires an email' do
      user = User.new(password: 'blah')
      user.validate

      expect(user.errors.full_messages).to include("Email address can't be blank")
    end
  end

  describe '#game_play_count' do
    it 'returns nil if there are no stats' do
      user = described_class.new(email_address: 'you@me.com', password: 'password')

      expect(user.game_play_count('chess')).to be nil
    end

    it 'returns nil if game name does not exist' do
      user = described_class.new(email_address: 'you@me.com', password: 'password')

      user.stats = {
        games: {
          checkers: {
            play_count: 10
          }
        }
      }
      expect(user.game_play_count('chess')).to be nil
    end

    it 'returns the play count if the game exists' do
      user = described_class.new(email_address: 'you@me.com', password: 'password')

      user.stats = {
        games: {
          chess: {
            play_count: 10
          }
        }
      }
      user.save!
      expect(user.game_play_count('chess')).to eq(10)
    end
  end
end
