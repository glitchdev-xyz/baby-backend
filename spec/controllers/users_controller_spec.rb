require 'rails_helper'
require 'webmock/rspec'

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
    let(:user) { create(:user_with_sessions, sessions_count: 1) }
    context 'with a successful billing api response' do
      let(:billing_response) { { subscription_status: 'active' } }
      before do
        stub_request(:get, "http://interviews-accounts.elevateapp.com:443/api/v1/users/#{user.id}/billing").
          with(
            headers: {
	      'Accept'=>'*/*',
	      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
	      'Authorization'=>'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiaWxsaW5nIiwiaWF0IjoxNzQzMDg1NDk5LCJleHAiOm51bGwsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImJpbGxpbmdfY2xpZW50In0.aRwnR_QP6AlOv_JanMkbhwe9ACDcJc5184pXdR0ksXg',
	      'User-Agent'=>'Ruby'
            }).
          to_return(status: 200, body: billing_response.to_json, headers: {})
      end

      it 'returns the user\'s stats' do


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
              total_games_played: 2,
            }
          }.merge(billing_response)
        }.to_json

        expect(response.body).to eq expected_response
      end
    end

    context 'with an error response from the billing api' do
      before do
        stub_request(:get, "http://interviews-accounts.elevateapp.com:443/api/v1/users/#{user.id}/billing").
          with(
            headers: {
	      'Accept'=>'*/*',
	      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
	      'User-Agent'=>'Ruby'
            }).
          to_return(status: 401)#, body: billing_response.to_json, headers: {})
      end

      it 'returns the user\'s stats with an error indicated in billing key' do
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
            },
            subscription_status: 'error'
          }
        }.to_json

        expect(response.body).to eq expected_response
      end
    end
  end
end
