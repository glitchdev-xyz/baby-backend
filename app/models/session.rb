class Session < ApplicationRecord
  belongs_to :user

  before_create :generate_token

  # TODO - check if there are best practices around exposing the token
  attr_reader :token
  private

  def generate_token
    self.token = Digest::SHA1.hexdigest([ Time.now, rand ].join)
  end
end
