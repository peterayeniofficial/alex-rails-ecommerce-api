# app/controllers/concerns/authorization.rb
module Authorization
  extend ActiveSupport::Concern
  include Pundit

  included do
    rescue_from Pundit::NotAuthorizedError, with: :forbidden
    after_action :verify_authorized
  end

  def authorize_actions
    if action_name == 'index'
      return authorize(controller_name.classify.constantize)
    end

    authorize resource
  end

  def forbidden
    render(status: 403)
  end

end