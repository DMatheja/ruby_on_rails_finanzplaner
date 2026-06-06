class AddLastVisitedToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :last_visited_at, :datetime
    add_column :users, :last_visited_page, :string
  end
end
