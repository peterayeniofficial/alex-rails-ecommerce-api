# app/models/api_key.rb
class ApiKey < ApplicationRecord
  before_validation :generate_key, on: :create
  validates :key, presence: true
  validates :active, presence: true
  scope :activated, -> { where(active: true) }

  def disable
    update_column :active, false
  end

  private

  def generate_key
    self.key = SecureRandom.hex
  end
end