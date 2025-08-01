require 'rails_helper'
describe 'User' do
  describe '#hello_world' do
    it 'returns Hello World' do
      user = User.new
      expect(user.hello_world).to eq('hi')
    end

    it 'has a secure password' do

      password_digest = BCrypt::Password.create("password")
      debugger
      user = User.create!(password_digest:, email_address: 'foo@bar.com')

    end

  end
end
