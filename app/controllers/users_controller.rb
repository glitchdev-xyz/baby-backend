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

  def stats
    user = User.find(Current.user.id)
    count = GameEvent.where(user_id: user.id).count
    payload =    {
      user: {
        id: user.id,
        email: user.email_address,
        stats: {
          total_games_played: count
        }
      }
    }
    render json: payload
  end
end
