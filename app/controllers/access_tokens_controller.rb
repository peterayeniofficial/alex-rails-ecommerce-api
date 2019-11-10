# app/controllers/access_tokens_controller.rb
class AccessTokensController < ApplicationController
  before_action :authenticate_user, only: :destroy

  def create
    skip_authorization # We add this
    user = User.find_by!(email: login_params[:email])

    if user.authenticate(login_params[:password])
      AccessToken.find_by(user: user, api_key: api_key).try(:destroy)

      access_token = AccessToken.create(user: user, api_key: api_key)
      token = access_token.generate_token

      params[:embed] = if params[:embed].present?
        params[:embed].prepend('user,')
      else
        'user'
      end

      render serialize(access_token, { token: token }).merge(status: :created)
    else
      render status: :unprocessable_entity,
             json: { error: { message: 'Invalid credentials.' } }
    end
  end

  def destroy
    authorize(access_token) # And this
    access_token.destroy
    render status: :no_content
  end

  private

  def login_params
    params.require(:data).permit(:email, :password)
  end

end