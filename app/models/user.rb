# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  has_many :categories, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :income_day,
  numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 31 }, allow_nil: true

  # Rate limiting
  MAX_ATTEMPTS = 3
  LOCKOUT_DURATION = 15.minutes
  
  def admin?
    role == 0
  end
  
  def user?
    role == 1
  end
  
  def viewer?
    role == 2
  end
  
  def locked_out?
    return false unless rate_limit_enabled
    locked_until.present? && locked_until > Time.current
  end
  
  def increment_failed_attempts
    update(failed_attempts: failed_attempts + 1)
    if rate_limit_enabled && failed_attempts >= MAX_ATTEMPTS
      update(locked_until: Time.current + LOCKOUT_DURATION)
    end
  end
  
  def reset_attempts
    update(failed_attempts: 0, locked_until: nil)
  end
end