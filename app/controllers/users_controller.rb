class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]

  def create
    permitted = params.expect(user: [:email_address, :password])


    User.create!(permitted)
    render json: {}, status: :created
  end

  private def user_params
    params.expect(person: [:name, :age])
  end

end
