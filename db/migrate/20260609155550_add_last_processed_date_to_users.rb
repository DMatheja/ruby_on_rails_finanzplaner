class AddLastProcessedDateToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :last_processed_date, :date

    reversible do |dir|
      dir.up do
        User.update_all(last_processed_date: Date.current)
      end
    end
  end
end
