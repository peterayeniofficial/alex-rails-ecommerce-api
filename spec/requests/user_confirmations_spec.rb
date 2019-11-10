# spec/requests/user_confirmations_spec.rb
require 'rails_helper'

RSpec.describe 'UserConfirmations', type: :request do

  describe 'GET /api/user_confirmations/:confirmation_token' do

    context 'with existing token' do

      context 'with confirmation redirect url' do
        subject { get "/api/user_confirmations/#{john.confirmation_token}" }
        let(:john) { create(:user, :confirmation_redirect_url) }

        it 'redirects to http://google.com' do
          expect(subject).to redirect_to('http://google.com')
        end
      end

      context 'without confirmation redirect url' do
        let(:john) { create(:user, :confirmation_no_redirect_url) }
        before { get "/api/user_confirmations/#{john.confirmation_token}" }

        it 'returns HTTP status 200' do
          expect(response.status).to eq 200
        end

        it 'renders "Your are now confirmed!"' do
          expect(response.body).to eq 'You are now confirmed!'
        end
      end
    end

    context 'with nonexistent token' do
      before { get '/api/user_confirmations/fake' }

      it 'returns HTTP status 404' do
        expect(response.status).to eq 404
      end

      it 'renders "Token not found"' do
        expect(response.body).to eq 'Token not found'
      end
    end

  end
end