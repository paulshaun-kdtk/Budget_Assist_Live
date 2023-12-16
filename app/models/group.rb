class Group < ApplicationRecord
    has_one_attached :icon
    # belongs_to :user
    has_many :payments

    def recent_payments(limit = 3)
        payments.order(created_at: :desc).limit(limit)
    end

    def total_amount
        payments.sum(:amount)
    end
end
