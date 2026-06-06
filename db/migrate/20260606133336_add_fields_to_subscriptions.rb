class AddFieldsToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :subscriptions, :billing_day, :integer, default: 1
    add_column :subscriptions, :subscription_type, :string, default: 'platform'
    add_column :subscriptions, :quantity, :integer, default: 1
  end
end
