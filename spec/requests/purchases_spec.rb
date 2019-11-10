# spec/requests/purchases_spec.rb
require 'rails_helper'

RSpec.describe 'Purchases', type: :request do
  include_context 'Skip Auth'

  before(:all) { Stripe.api_key ||= ENV['STRIPE_API_KEY'] }

  let(:book) { create(:ruby_on_rails_tutorial, price_cents: 299) }
  let(:purchase) { create(:purchase, book: book) }

  describe 'GET /api/purchases' do
    before do
      purchase
      get '/api/purchases'
    end

    it 'gets HTTP status 200' do
      expect(response.status).to eq 200
    end

    it 'receives the only purchase in the db' do
      expect(json_body['data'].size).to eq 1
      expect(json_body['data'].first['id']).to eq purchase.id
    end
  end # describe 'GET /api/purchases' end

  describe 'GET /api/purchases/:id' do

    context 'with existing resource' do
      before { get "/api/purchases/#{purchase.id}" }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives the purchase as JSON' do
        expected = { data: PurchasePresenter.new(purchase, {}).fields.embeds }
        expect(response.body).to eq(expected.to_json)
      end
    end

    context 'with nonexistent resource' do
      it 'gets HTTP status 404' do
        get '/api/purchases/2314323'
        expect(response.status).to eq 404
      end
    end
  end # describe 'GET /purchases/:id' end

  describe 'POST /api/purchases' do
    context 'with valid parameters' do
      let(:card) do
        { number: '4242424242424242', exp_month: 6, exp_year: 2028, cvc: "314" }
      end
      let(:token) { Stripe::Token.create(card: card)['id'] }
      let(:params) { attributes_for(:purchase, book_id: book.id, token: token) }

      it 'gets HTTP status 201' do
        VCR.use_cassette('/api/purchases/valid_params') do
          post '/api/purchases', params: { data: params }
          expect(response.status).to eq 201
        end
      end

      it 'returns the newly created resource' do
        VCR.use_cassette('/api/purchases/valid_params') do
          post '/api/purchases', params: { data: params }
          expect(json_body['data']['book_id']).to eq book.id
        end
      end

      it 'adds a record in the database' do
        VCR.use_cassette('/api/purchases/valid_params') do
          post '/api/purchases', params: { data: params }
          expect(Purchase.count).to eq 1
        end
      end

      it 'returns the new resource location in the Location header' do
        VCR.use_cassette('/api/purchases/valid_params') do
          post '/api/purchases', params: { data: params }
          expect(response.headers['Location']).to eq(
            "http://www.example.com/api/purchases/#{Purchase.first.id}"
          )
        end
      end
    end

    context 'with invalid parameters' do
      let(:params) { attributes_for(:purchase, token: '') }
      before { post '/api/purchases', params: { data: params } }

      it 'gets HTTP status 422' do
        expect(response.status).to eq 422
      end

      it 'receives an error details' do
        expect(json_body['error']['invalid_params']).to eq(
          {"book"=>["must exist", "can't be blank"], "token"=>["can't be blank"]}
        )
      end

      it 'does not add a record in the database' do
        expect(Purchase.count).to eq 0
      end
    end # context 'with invalid parameters'
  end # describe 'POST /purchases'
end