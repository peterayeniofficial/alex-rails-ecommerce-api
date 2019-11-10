# app/presenters/purchase_presenter.rb
class PurchasePresenter < BasePresenter
  cached
  build_with    :id, :book_id, :user_id, :price_cents, :price_currency,
                :idempotency_key, :status, :charge_id, :error, :created_at,
                :updated_at
  related_to    :user, :book
  sort_by       :id, :book_id, :user_id, :price_cents, :price_currency, :status,
                :created_at, :updated_at
  filter_by     :id, :book_id, :user_id, :price_cents, :price_currency,
                :idempotency_key, :status, :charge_id, :error, :created_at,
                :updated_at
end