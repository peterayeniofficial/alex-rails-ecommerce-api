# spec/policies/book_policy_spec.rb
require 'rails_helper'

describe BookPolicy do
  subject { described_class }

  permissions :index?, :show? do
    it 'grants access' do
      expect(subject).to permit(nil, Book.new)
    end
  end

  permissions :create?, :update?, :destroy? do
    it 'denies access if user is not admin' do
      expect(subject).not_to permit(build(:user), Book.new)
    end

    it 'grants access if user is admin' do
      expect(subject).to permit(build(:admin), Book.new)
    end
  end
end