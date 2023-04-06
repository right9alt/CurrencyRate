class Rate < ApplicationRecord
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
