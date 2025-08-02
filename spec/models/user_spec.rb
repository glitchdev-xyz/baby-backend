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
end
