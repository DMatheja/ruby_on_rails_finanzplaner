class AddPasswordAndRateLimitingToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :rate_limit_enabled, :boolean, default: true
    add_column :users, :failed_attempts, :integer, default: 0
    add_column :users, :locked_until, :datetime
  end
end
