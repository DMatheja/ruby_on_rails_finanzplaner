# app/models/subscription.rb
class Subscription < ApplicationRecord
  belongs_to :user
  
  TYPES = ['platform', 'regular'].freeze

  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :frequency, presence: true, inclusion: { in: ['monthly', 'weekly'] }
  validates :start_date, presence: true
  validates :billing_day, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }
  validates :subscription_type, inclusion: { in: TYPES }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }, if: -> { subscription_type == 'regular' }
end