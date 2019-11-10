# spec/connectors/stripe_connector_spec.rb
require 'rails_helper'

RSpec.describe StripeConnector do
  before(:all) { Stripe.api_key ||= ENV['STRIPE_API_KEY'] }

  let(:book) { create(:book, price_cents: 299) }
  let(:purchase) { create(:purchase, book: book) }

  def charge_with_token(purchase, card)
    token = Stripe::Token.create(card: card)
    purchase.update_column :token, token['id']
    StripeConnector.new(purchase).send(:create_charge)
  end

  def card(number)
    { number: number, exp_month: 6, exp_year: 2028, cvc: "314" }
  end

  context 'with valid card' do
    let(:valid_card) { card('4242424242424242') }

    it 'succeeds' do
      VCR.use_cassette('stripe/valid_card') do
        charge = charge_with_token(purchase, valid_card)

        expect(charge['status']).to eq 'succeeded'
        expect(purchase.reload.charge_id).to eq charge['id']
        expect(purchase.reload.status).to eq 'confirmed'
      end
    end
  end

  context 'with invalid card' do
    let(:invalid_card) { card('4000000000000002') }

    it 'declines the card' do
      VCR.use_cassette('stripe/invalid_card') do
        charge = charge_with_token(purchase, invalid_card)

        expect(charge[:error][:code]).to eq 'card_declined'
        expect(purchase.reload.error).to eq charge[:error].stringify_keys
        expect(purchase.reload.status).to eq 'rejected'
      end
    end
  end

end