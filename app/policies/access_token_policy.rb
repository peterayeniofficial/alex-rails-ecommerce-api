# app/policies/access_token_policy.rb
class AccessTokenPolicy < ApplicationPolicy

  def create?
    true
  end

  def destroy?
    @user == @record.user
  end

end