require 'rails_helper'

describe Session do
  describe 'validations' do
    it 'requires a user association' do
      session = Session.new
      session.validate
      expect(session.errors.full_messages).to include('User must exist')
    end
  end
end
