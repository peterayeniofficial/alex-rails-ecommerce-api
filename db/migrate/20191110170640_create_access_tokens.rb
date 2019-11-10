class CreateAccessTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :access_tokens do |t|
      t.string :token_digest
      t.references :user, foreign_key: true
      t.references :api_key, foreign_key: true
      t.timestamp :accessed_at

      t.timestamps
    end
    add_index :access_tokens, [:user_id, :api_key_id], unique: true
  end
end
