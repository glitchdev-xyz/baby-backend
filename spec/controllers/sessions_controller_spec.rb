require 'rails_helper'

describe SessionsController do
  # Not concerned about record pollution. Just reloading routes.
  # rubocop:disable RSpec/BeforeAfterAll
  after :all do
    Rails.application.reload_routes!
  end
  # rubocop:enable RSpec/BeforeAfterAll

  describe '#create' do
    before do
      Rails.application.routes.draw do
        get '/create', to: "sessions#create"
      end
    end

    it 'responds with status unauthorized when user does not authenticate' do
      allow(User).to receive(:authenticate_by).and_return(nil)

      get :create
      expect(response.status).to eq 401
    end

    context 'when a user can authenticate' do
      it 'responds with status success when user can authenticate' do
        user = create(:user_with_sessions)
        allow(User).to receive(:authenticate_by).and_return(user)

        get :create
        expect(response.status).to eq 200
      end

      it 'creates a new session for the user' do
        user = create(:user)
        allow(User).to receive(:authenticate_by).and_return(user)

        # Set up to spy on user.sessions.create! in
        # Authentication concern's start_new_session_for
        allow(user.sessions).to receive(:create!).and_call_original

        get :create
        expect(user.sessions).to(
          have_received(:create!)
            .with(
              user_agent: request.user_agent,
              ip_address: request.remote_ip
            )
        )
      end

      it 'returns the session token to the user' do
        user = create(:user)
        allow(User).to receive(:authenticate_by).and_return(user)
        get :create
        response_token = response.parsed_body['token']
        expect(response_token).to eq(user.sessions.first.token)
      end

      it 'sets current_session in global state' do
        pending 'Decide if it is worth testing this here.'
      end
    end
  end
end
