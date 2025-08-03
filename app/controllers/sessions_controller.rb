class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    expected_params = params.expect(user: [:email_address, :password])
    email_address = expected_params[:email_address]
    password = expected_params[:password]

    if user = User.authenticate_by(email_address:, password:)
      start_new_session_for user
      render json: { token: Current.session.token }
    else
      render json: {}, status: :unauthorized
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
