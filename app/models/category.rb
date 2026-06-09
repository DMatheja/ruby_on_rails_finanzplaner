# app/models/category.rb
class Category < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  
  validates :name, presence: true
  validates :user_id, presence: true
  
  def spent_amount
    products.where(status: 'purchased').sum('price * amount')
  end

  def total_amount
    products.sum('price * amount')
  end
  
  def remaining_budget
    limit - spent_amount
  end
end