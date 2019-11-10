# spec/policies/purchase_policy_spec.rb
require 'rails_helper'

describe PurchasePolicy do
  subject { described_class }

  describe '.scope' do
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }
    let(:rails_tuto) { create(:ruby_on_rails_tutorial) }
    let(:ruby_micro) { create(:ruby_microscope) }
    let(:purchase_admin) { create(:purchase, user: admin, book: ruby_micro) }
    let(:purchase_user) { create(:purchase, user: user, book: rails_tuto) }

    before { purchase_admin && purchase_user }

    context 'when admin' do
      let(:scope) { PurchasePolicy::Scope.new(admin, Purchase.all).resolve }

      it 'gets all the purchases' do
        expect(scope).to include(purchase_admin)
        expect(scope).to include(purchase_user)
      end
    end

    context 'when regular user' do
      let(:scope) { PurchasePolicy::Scope.new(user, Purchase.all).resolve }

      it 'gets all the purchases that belong to the user' do
        expect(scope).to_not include(purchase_admin)
        expect(scope).to include(purchase_user)
      end
    end
  end

  permissions :index?, :create? do
    it 'grants access' do
      expect(subject).to permit(User.new, Purchase)
    end
  end

  permissions :show? do
    context 'when regular user' do
      it 'denies access if the user and record owner are different' do
        expect(subject).not_to permit(User.new, Purchase.new)
      end

      it 'grants access if the user and record owner are the same' do
        user = User.new
        expect(subject).to permit(user, Purchase.new(user: user))
      end
    end

    context 'when admin' do
      it 'grants access' do
        expect(subject).to permit(build(:admin), Purchase.new)
      end
    end
  end
end