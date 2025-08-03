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
      it '' do
        pending 'Assert that it responds appropriately'
      end
    end
  end
end
