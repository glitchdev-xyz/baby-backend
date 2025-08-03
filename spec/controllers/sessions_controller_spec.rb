require 'rails_helper'

describe SessionsController do
  describe '#create' do
    let(:params) do
      {
        user: {
          email_address: 'foo@bar.zoo',
          password: 'password'
        }
      }
    end

    it 'responds with status unauthorized when user does not authenticate' do
      get(:create, params:)
      expect(response.status).to eq 401
    end

    context 'when a user can authenticate' do
      it 'responds with status success when user can authenticate' do
        user = create(:user_with_sessions)
        allow(User).to receive(:authenticate_by).and_return(user)
        get(:create, params:)

        expect(response.status).to eq 200
      end

      it 'creates a new session for the user' do
        user = create(:user)
        allow(User).to receive(:authenticate_by).and_return(user)

        # Set up to spy on user.sessions.create! in
        # Authentication concern's start_new_session_for
        allow(user.sessions).to receive(:create!).and_call_original
        get(:create, params:)

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
        get(:create, params:)
        response_token = response.parsed_body['token']
        expect(response_token).to eq(user.sessions.first.token)
      end
    end
  end
end
