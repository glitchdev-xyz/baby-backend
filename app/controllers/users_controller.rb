class UsersController < ApplicationController
  require 'net/http'
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

  private def subscription_status(user)
    uri = URI.parse(billing_url(user))
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = "Bearer #{billing_token}"
    response = http.request(request)

    return nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end

  private def billing_url(user)
    "https://interviews-accounts.elevateapp.com/api/v1/users/#{user.id}/billing"
  end
  # TODO: Prototype only
  private def billing_token
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiaWxsaW5nIiwiaWF0IjoxNzQzMDg1NDk5LCJleHAiOm51bGwsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImJpbGxpbmdfY2xpZW50In0.aRwnR_QP6AlOv_JanMkbhwe9ACDcJc5184pXdR0ksXg'
  end
end
