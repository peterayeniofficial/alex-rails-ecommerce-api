# spec/policies/download_policy_spec.rb
require 'rails_helper'

describe DownloadPolicy do
  subject { described_class }

  permissions :show? do
    context 'when admin' do
      it 'grants access' do
        expect(subject).to permit(build(:admin), Purchase.new)
      end
    end

    context 'when not admin' do
      it 'denies access if the user did not buy the book' do
        user = create(:user)
        expect(subject).not_to permit(user, create(:book))
      end

      it 'grants access if the user has bought the book' do
        user = create(:user)
        book = create(:book)
        create(:purchase, user: user, book: book)
        expect(subject).to permit(user, book)
      end
    end
  end
end