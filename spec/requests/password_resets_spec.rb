# spec/requests/password_resets_spec.rb
require 'rails_helper'

RSpec.describe 'PasswordResets', type: :request do

  let(:john) { create(:user) }

  describe 'POST /api/password_resets' do

    # This resource can only be accessed by an authenticated client.
    # For those steps, we will skip the authentication
    before do
      allow_any_instance_of(PasswordResetsController).to(
        receive(:validate_auth_scheme).and_return(true))
      allow_any_instance_of(PasswordResetsController).to(
        receive(:authenticate_client).and_return(true))
    end

    context 'with valid parameters' do
      let(:params) do
        {
          data: {
            email: john.email,
            reset_password_redirect_url: 'http://example.com'  
          }
        }
      end
      before { post '/api/password_resets', params: params }

      it 'returns 204' do
        expect(response.status).to eq 204
      end

      it 'sends the reset password email' do
        expect(ActionMailer::Base.deliveries.last.subject).to eq(
          'Reset your password'
        )
      end

      # Here we check that all the fields have properly been updated
      it 'adds the reset password attributes to "john"' do
        expect(john.reset_password_token).to be nil
        expect(john.reset_password_sent_at).to be nil
        updated = john.reload
        expect(updated.reset_password_token).to_not be nil
        expect(updated.reset_password_sent_at).to_not be nil
        expect(updated.reset_password_redirect_url).to eq 'http://example.com'
      end
    end

    context 'with invalid parameters' do
      let(:params) { { data: { email: john.email } } }
      before { post '/api/password_resets', params: params }

      it 'returns HTTP status 422' do
        expect(response.status).to eq 422
      end
    end

    context 'with nonexistent user' do
      let(:params) { { data: { email: 'fake@example.com' } } }
      before { post '/api/password_resets', params: params }

      it 'returns HTTP status 404' do
        expect(response.status).to eq 404
      end
    end
  end

  describe 'GET /api/password_resets/:reset_token' do

    context 'with existing user (valid token)' do
      subject { get "/api/password_resets/#{john.reset_password_token}" }

      context 'with redirect URL containing parameters' do
        let(:john) { create(:user, :reset_password) }

        it 'redirects to "http://example.com?some=params&reset_token=TOKEN"' do
          token = john.reset_password_token
          expect(subject).to redirect_to(
           "http://example.com?some=params&reset_token=#{token}"
          )
        end
      end

      context 'with redirect URL not containing any parameters' do
        let(:john) { create(:user, :reset_password_no_params) }

        it 'redirects to "http://example.com?reset_token=TOKEN"' do
          expect(subject).to redirect_to(
            "http://example.com?reset_token=#{john.reset_password_token}"
          )
        end
      end
    end

    context 'with nonexistent user' do
      before { get "/api/password_resets/123" }

      it 'returns HTTP status 404' do
        expect(response.status).to eq 404
      end
    end
  end # 'GET /password_resets/:reset_token'

  describe 'PATCH /api/password_resets/:reset_token' do

    before do
      allow_any_instance_of(PasswordResetsController).to(
        receive(:validate_auth_scheme).and_return(true))
      allow_any_instance_of(PasswordResetsController).to(
        receive(:authenticate_client).and_return(true))
    end

    context 'with existing user (valid token)' do
      let(:john) { create(:user, :reset_password) }
      before do
        patch "/api/password_resets/#{john.reset_password_token}", params: params
      end

      context 'with valid parameters' do
        let(:params) { { data: { password: 'new_password' } } }

        it 'returns HTTP status 204' do
          expect(response.status).to eq 204
        end

        it 'updates the password' do
          expect(john.reload.authenticate('new_password')).to_not be false
        end
      end

      context 'with invalid parameters' do
        let(:params) { { data: { password: '' } } }

        it 'returns HTTP status 422' do
          expect(response.status).to eq 422
        end
      end
    end

    context 'with nonexistent user' do
      before do
        patch '/api/password_resets/123', params: {
          data: { password: 'password' }
        }
      end

      it 'returns HTTP status 404' do
        expect(response.status).to eq 404
      end
    end
  end # 'PATCH /password_resets/:reset_token' end
  
end