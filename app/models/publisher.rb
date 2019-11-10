class Publisher < ApplicationRecord
  include PgSearch
  multisearchable against: [:name]
  
  has_many :books
  validates :name, presence: true
  
end
