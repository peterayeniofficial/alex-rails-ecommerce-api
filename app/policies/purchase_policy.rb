# app/policies/purchase_policy.rb
class PurchasePolicy < ApplicationPolicy

  def index?
    user
  end

  def show?
    user.admin? || record.user == user
  end

  def create?
    user
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

end