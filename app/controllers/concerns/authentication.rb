# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  AUTH_SCHEME = 'Alexandria-Token'

  included do
    before_action :validate_auth_scheme
  end

  protected

  def validate_auth_scheme
    unless authorization_request.match(/^#{AUTH_SCHEME} /)
      unauthorized!('Client Realm')
    end
  end

  def unauthorized!(realm)
    headers['WWW-Authenticate'] = %(#{AUTH_SCHEME} realm="#{realm}")
    render(status: 401)
  end

  def authorization_request
    @authorization_request ||= request.authorization.to_s
  end

  def credentials
    @credentials ||= Hash[authorization_request.scan(/(\w+)[:=] ?"?([\w|:]+)"?/)]
  end

  def api_key
    @api_key ||= compute_api_key
  end

  def compute_api_key
    return nil if credentials['api_key'].blank?

    id, key = credentials['api_key'].split(':')
    api_key = id && key && ApiKey.activated.find_by(id: id)

    return api_key if api_key && secure_compare_with_hashing(api_key.key, key)
  end

  def secure_compare_with_hashing(a, b)
    secure_compare(Digest::SHA1.hexdigest(a), Digest::SHA1.hexdigest(b))
  end


end