# app/models/password_reset.rb
class PasswordReset
  include ActiveModel::Model

  attr_accessor :email, :reset_password_redirect_url, :password,
                :reset_token, :updating

  validates :email, presence: true, unless: :updating
  validates :reset_password_redirect_url, presence: true, unless: :updating
  validates :password, presence: true, if: :updating

  def create
    user && valid? && user.init_password_reset(reset_password_redirect_url)
  end

  def redirect_url
    build_redirect_url
  end

  def update
    self.updating = true
    user && valid? && user.complete_password_reset(password)
  end

  def user
    @user ||= retrieve_user
  end

  private

  def retrieve_user
    user = email ? user_with_email : user_with_token
    raise ActiveRecord::RecordNotFound unless user
    user
  end

  def user_with_email
    User.where(email: email).first
  end

  def user_with_token
    User.where(reset_password_token: reset_token).first
  end

  def build_redirect_url
    url = user.reset_password_redirect_url
    query_params = Rack::Utils.parse_query(URI(url).query)
    if query_params.any?
      "#{url}&reset_token=#{reset_token}"
    else
      "#{url}?reset_token=#{reset_token}"
    end
  end

end