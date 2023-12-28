class Payment < ApplicationRecord
  belongs_to :group, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
end
