require 'rails_helper'

RSpec.describe Group, type: :model do
  describe '#recent_payments' do
    it 'returns the specified number of recent payments' do
      group = Group.create(name: 'Test Group')
      payment1 = Payment.create(group:, amount: 50, created_at: 1.day.ago)
      payment2 = Payment.create(group:, amount: 50, created_at: 2.days.ago)
      payment3 = Payment.create(group:, amount: 50, created_at: 3.days.ago)
      payment4 = Payment.create(group:, amount: 50, created_at: 4.days.ago)

      recent_payments = group.recent_payments(3)

      expect(recent_payments).to eq([payment1, payment2, payment3])
    end

    it 'returns all payments if the specified limit is greater than the total number of payments' do
      group = Group.create(name: 'Test Group')
      payment1 = Payment.create(group:, amount: 50, created_at: 1.day.ago)
      payment2 = Payment.create(group:, amount: 50, created_at: 2.days.ago)

      recent_payments = group.recent_payments(3)

      expect(recent_payments).to eq([payment1, payment2])
    end
  end

  describe '#total_amount' do
    it 'returns the sum of all payment amounts for the group' do
      group = Group.create(name: 'Test Group')
      payment1 = Payment.create(group:, amount: 50)
      payment2 = Payment.create(group:, amount: 30)
      payment3 = Payment.create(group:, amount: 20)

      total_amount = group.total_amount

      expect(total_amount).to eq(100)
    end

    it 'returns 0 if the group has no payments' do
      group = Group.create(name: 'Test Group')

      total_amount = group.total_amount

      expect(total_amount).to eq(0)
    end
  end
end
