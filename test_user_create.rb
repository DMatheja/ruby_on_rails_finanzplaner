require './config/environment'
user = User.create!(name: "InitTestUser#{Time.now.to_i}", password: "password")
puts "last_processed_date is #{user.last_processed_date}"
