module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
  def require_authentication
    authenticate_with_http_token do |token, options|
      session = Session.where(token:).first
      render json: {}, status: :unauthorized unless session

      Current.session = session
    end
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      Current.session = session
    end
  end
end
