require 'rails_helper'

describe 'api/user' do
  it 'responds with created status with valid params' do
    post '/api/user', params: { user: {email_address: 'an@email.com', password: 'password123'}}

    expect(response).to have_http_status(:created)
  end

  it 'responds with unprocessable content with missing user params' do
    post '/api/user', params: { user: { password: 'password123'}}

    expect(response).to have_http_status(:unprocessable_content)
  end

  it 'responds with bad request with empty params' do
    post '/api/user', params: {}

    expect(response).to have_http_status(:bad_request)
  end
end

describe 'POST api/sessions' do

end
