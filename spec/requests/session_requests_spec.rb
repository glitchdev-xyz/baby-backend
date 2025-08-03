require 'rails_helper'

describe 'api/sessions' do
  it 'responds with success status with valid params' do
    password = 'password1'
    user = create(:user, password:)
    params = {
      user: {
        email_address: user.email_address,
        password:
      }
    }
    post('/api/sessions', params:)

    expect(response).to have_http_status(:success)
  end

  it 'responds with unauthorized with missing params' do
    user = create(:user)
    params = {
      user: {
        email_address: user.email_address
      }
    }
    post('/api/sessions', params:)

    expect(response).to have_http_status(:unauthorized)
  end
end
