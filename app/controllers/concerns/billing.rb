module Billing
  extend ActiveSupport::Concern

  def billing_request(user)
    uri = URI.parse(billing_url(user))
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = "Bearer #{billing_token}"
    response = http.request(request)

    return nil unless response.is_a?(Net::HTTPSuccess)

    response
  end

  private

  def billing_url(user)
    "https://interviews-accounts.elevateapp.com/api/v1/users/#{user.id}/billing"
  end

  # TODO: Prototype only
  def billing_token
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiaWxsaW5nIiwiaWF0IjoxNzQzMDg1NDk5LCJleHAiOm51bGwsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImJpbGxpbmdfY2xpZW50In0.aRwnR_QP6AlOv_JanMkbhwe9ACDcJc5184pXdR0ksXg'
  end
end
