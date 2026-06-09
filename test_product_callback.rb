require './config/environment'
user = User.create!(name: "TestUser#{Time.now.to_i}", password: "password")
category = Category.create!(name: "Test", user: user)
puts "Initial balance: #{user.balance}"
product = Product.create!(name: "Test Product", price: 100, category: category, status: 'purchased')
user.reload
puts "Balance after create as purchased: #{user.balance}"
product2 = Product.create!(name: "Test Product 2", price: 50, category: category, status: 'pending')
user.reload
puts "Balance after create as pending: #{user.balance}"
product2.update!(status: 'purchased')
user.reload
puts "Balance after update to purchased: #{user.balance}"
