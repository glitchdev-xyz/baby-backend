class UsersController < ApplicationController
  require 'net/http'
  include Billing

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
    subscription_status = subscription_status(user)
    payload = {
      user: {
        id: user.id,
        email: user.email_address,
        stats: {
          total_games_played: count
        }
      }
    }
    if subscription_status
      payload[:user].merge!(subscription_status)
    else
      payload[:user].merge!({ subscription_status: 'error' })
    end

    render json: payload.to_json
  end

  # TODO - this is not tested yet & might have bugs!
  # also, line 49 is kinda gross.
  private def subscription_status(user)
    if user.subscription_status && user.subscription_status.created_at.to_date < 1.day.ago
      user.subscription_status
    end

    subscription_status_request(user)
  end

  private def subscription_status_request(user)
    response = billing_request(user)
    return nil unless response

    JSON.parse(response.body)
  end
end
