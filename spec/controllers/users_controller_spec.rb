require 'rails_helper'

describe UsersController do
  describe 'POST create' do
    context 'with valid, required params' do
      it 'responsds with status created' do
        params = { user: { email_address: 'you@me.com', password: 'password123' } }
        post(:create, params:)

        expect(response.status).to eq 201
      end
    end

    context 'with invalid params' do
      # TODO
    end
  end

  describe 'POST create_event' do
    it 'creates a game event record' do
      user = create(:user_with_sessions, sessions_count: 1)
      request.headers['Authorization'] = "Token token=\"#{user.sessions.first.token}\""

      params = {
        game_event: {
          game_name: "Brevity",
          type: "COMPLETED",
          occurred_at: "2025-01-01T00:00:00.000Z"
        }
      }
      post(:create_event, params:)
      expect(response.status).to eq 204
    end
  end

  describe 'GET stats' do
    it 'returns the user\'s stats' do
      user = create(:user_with_sessions, sessions_count: 1)

      ['Zelda II', 'Kingdom of Kroz'].each do |game_name|
        GameEvent.create(user_id: user.id, event_type: 'COMPLETED', game_name:)
      end

      request.headers['Authorization'] = "Token token=\"#{user.sessions.first.token}\""
      get(:stats)

      expected_response = {
        user: {
          id: user.id,
          email: user.email_address,
          stats: {
            total_games_played: 2
          }
        }
      }.to_json

      expect(response.body).to eq expected_response
    end
  end
end
