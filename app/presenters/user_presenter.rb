# app/presenters/user_presenter.rb
class UserPresenter < BasePresenter
    FIELDS = [:id, :email, :given_name, :family_name, :role, :last_logged_in_at,
             :confirmed_at, :confirmation_sent_at, :reset_password_sent_at,
             :created_at, :updated_at]
    related_to :access_tokens
    sort_by    *FIELDS
    filter_by  *FIELDS
    build_with  *[FIELDS.push([:confirmation_token, :reset_password_token,
                               :confirmation_redirect_url,
                               :reset_password_redirect_url])].flatten
  end