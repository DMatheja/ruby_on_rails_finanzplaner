# app/models/subscription.rb
class Subscription < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :frequency, presence: true, inclusion: { in: ['monthly', 'weekly'], message: "'%{value}' is not valid" }
  validates :start_date, presence: true
end
