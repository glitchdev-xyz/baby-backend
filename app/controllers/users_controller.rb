class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]

  def create
    permitted = params.expect(user: [:email_address, :password])

    User.create!(permitted)
    render json: {}, status: :created
  end

  def create_event
    permitted = params.expect(game_event: [:type, :game_name, :occurred_at])

    GameEvent.create!(
      game_name:  permitted[:game_name],
      event_type: permitted[:type],
      occurred_at: permitted[:occurred_at],
      user_id: Current.user.id
    )
  end
end
