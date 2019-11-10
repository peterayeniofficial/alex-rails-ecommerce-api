# app/controllers/password_resets_controller.rb
class PasswordResetsController < ApplicationController
  skip_before_action :validate_auth_scheme, only: :show
  skip_before_action :authenticate_client, only: :show
  before_action :skip_authorization


  def show
    reset = PasswordReset.new({ reset_token: params[:reset_token] })
    redirect_to reset.redirect_url
  end

  def create
    if reset.create
      UserMailer.reset_password(reset.user).deliver_now
      render status: :no_content, location: reset.user
    else
      unprocessable_entity!(reset)
    end
  end

  def update
    reset.reset_token = params[:reset_token]
    if reset.update
      render status: :no_content
    else
      unprocessable_entity!(reset)
    end
  end

  private

  def reset
    @reset ||= reset = PasswordReset.new(reset_params)
  end

  def reset_params
    params.require(:data).permit(:email, :reset_password_redirect_url, :password)
  end
end