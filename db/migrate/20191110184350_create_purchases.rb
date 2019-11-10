# db/migrate/TIMESTAMP_create_purchases.rb
class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.references :book, foreign_key: true, index: true
      t.references :user, foreign_key: true
      t.monetize :price
      t.string :idempotency_key
      t.integer :status, default: 0
      t.string :charge_id
      t.string :token
      t.text :error, default: '{}', null: false

      t.timestamps
    end

    add_index :purchases, [:user_id, :book_id]
  end
end