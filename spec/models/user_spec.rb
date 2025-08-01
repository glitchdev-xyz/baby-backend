require 'rails_helper'
describe 'User' do
  describe '#hello_world' do
    it 'returns Hello World' do
      user = User.new
      expect(user.hello_world).to eq('hi')
    end
  end
end
