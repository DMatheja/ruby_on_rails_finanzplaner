class AddIncomeDayToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :income_day, :integer, default: 1
  end
end
