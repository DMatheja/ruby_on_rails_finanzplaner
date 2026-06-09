# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :category, optional: true
  
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :amount, numericality: { greater_than: 0 }
  
  # Deduct from user balance when marked as purchased
  after_save :deduct_from_balance, if: proc { |product| product.saved_change_to_status? && product.status == 'purchased' }
  
  private
  
  def deduct_from_balance
    return unless category.present?
    user = category.user
    total = price * amount
    user.update(balance: user.balance - total)
  end
end