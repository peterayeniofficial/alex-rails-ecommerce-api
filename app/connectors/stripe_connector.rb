# app/connectors/stripe_connector.rb
class StripeConnector

  def initialize(purchase)
    @purchase = purchase

    # We need to set the API key if it hasn't been
    # set yet
    Stripe.api_key ||= ENV['STRIPE_API_KEY']
  end

  def charge
    @purchase.sent!
    create_charge
    @purchase
  end

  private

  def create_charge
    begin
      # Let's get some money!
      charge = Stripe::Charge.create(stripe_hash, {
        idempotency_key: @purchase.idempotency_key
      })

      # No error raised? Let's confirm the purchase.
      @purchase.confirm!(charge.id)
      charge
    rescue Stripe::CardError => e
      # If we get an error, we save it in the purchase.
      # The controller can then send it back to the client.
      body = e.json_body
      @purchase.error!(body[:error])
      body
    end
  end

  # Here we build the hash that will get submitted to
  # Stripe.
  def stripe_hash
    {
      amount: @purchase.price.fractional,
      currency: @purchase.price.currency.to_s,
      source: @purchase.token,
      metadata: { purchase_id: @purchase.id },
      description: description
    }
  end

  def description
    "Charge for #{@purchase.book.title} (Purchase ID #{@purchase.id})"
  end

end