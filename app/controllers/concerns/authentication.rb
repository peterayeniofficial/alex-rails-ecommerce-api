# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  AUTH_SCHEME = 'Alexandria-Token'

  included do
    before_action :validate_auth_scheme
    before_action :authenticate_client
  end

  private

  def validate_auth_scheme
    unless authorization_request.match(/^#{AUTH_SCHEME} /)
      unauthorized!('Client Realm')
    end
  end

  def authenticate_client
    unauthorized!('Client Realm') unless api_key
  end

  def authenticate_user
    unauthorized!('User Realm') unless access_token
  end

  def unauthorized!(realm)
    headers['WWW-Authenticate'] = %(#{AUTH_SCHEME} realm="#{realm}")
    render(status: 401)
  end

  def authorization_request
    @authorization_request ||= request.authorization.to_s
  end

  def authenticator
    @authenticator ||= Authenticator.new(authorization_request)
  end

  def api_key
    @api_key ||= -> do
      key = "api_keys/#{authenticator.credentials['api_key']}"

      Rails.cache.fetch(key, expires_in: 24.hours) do
        authenticator.api_key
      end
    end.call
  end


  def access_token
    @access_token ||= authenticator.access_token
  end

  def current_user
    @current_user ||= access_token.try(:user)
  end

end