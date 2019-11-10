# spec/requests/downloads_spec.rb
require 'rails_helper'

RSpec.describe 'Access Tokens', type: :request do
  include_context 'Skip Auth'

  let(:book) { create(:book, download_url: 'http://example.com') }

  describe 'GET /api/books/:book_id/download' do

    context 'with an existing book' do

      before { get "/api/books/#{book.id}/download" }

      it 'returns 204' do
        expect(response.status).to eq 204
      end

      it 'returns the download url in the Location header' do
        expect(response.headers['Location']).to eq 'http://example.com'
      end

    end

    context 'with nonexistent book' do
      it 'returns 404' do
        get '/api/books/123/download'
        expect(response.status).to eq 404
      end
    end
  end
end