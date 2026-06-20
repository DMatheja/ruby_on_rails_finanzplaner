class FinanzplanerSetup < ActiveRecord::Migration[7.0]
  def change
    # Benutzer
    create_table :users do |t|
      t.string :name
      t.integer :role, default: 1 # 0=admin, 1=user, 2=viewer
      t.decimal :balance, precision: 10, scale: 2, default: 10000.00
      t.decimal :income, precision: 10, scale: 2, default: 2000.00
      t.timestamps
    end

    # Kategorien
    create_table :categories do |t|
      t.string :name
      t.decimal :limit, precision: 10, scale: 2
      t.references :user, foreign_key: true
      t.timestamps
    end

    # Produkte
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :amount, default: 1
      t.string :status, default: "pending" # "pending" oder "purchased"
      t.references :category, foreign_key: true
      t.timestamps
    end

    # Abonnements (Subscriptions)
    create_table :subscriptions do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.string :frequency # "monthly", "weekly"
      t.date :start_date
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
