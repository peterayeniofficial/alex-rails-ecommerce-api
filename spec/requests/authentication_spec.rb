# spec/requests/authentication_spec.rb
require 'rails_helper'

RSpec.describe 'Authentication', type: :request do

  describe 'Client Authentication' do
    before { get '/api/books', headers: headers }

    context 'with invalid authentication scheme' do
      let(:headers) { { 'HTTP_AUTHORIZATION' => '' } }

      it 'gets HTTP status 401 Unauthorized' do
        expect(response.status).to eq 401
      end
    end

    context 'with valid authentication scheme' do
      let(:headers) do
         { 'HTTP_AUTHORIZATION' =>
            "Alexandria-Token api_key=#{api_key.id}:#{api_key.key}" }
      end

      context 'with invalid API Key' do
        let(:api_key) { OpenStruct.new(id: 1, key: 'fake') }
        it 'gets HTTP status 401 Unauthorized' do
          expect(response.status).to eq 401
        end
      end

      context 'with disabled API Key' do
        let(:api_key) { ApiKey.create.tap { |key| key.disable } }
        it 'gets HTTP status 401 Unauthorized' do
          expect(response.status).to eq 401
        end
      end

      context 'with valid API Key' do
        let(:api_key) { ApiKey.create }
        it 'gets HTTP status 200' do
          expect(response.status).to eq 200
        end
      end
    end # context 'with valid authentication scheme' end
  end
end