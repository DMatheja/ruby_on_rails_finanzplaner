# db/seeds.rb

# User
User.find_or_create_by!(name: "max") do |u|
  u.password              = "123456"
  u.password_confirmation = "123456"
  u.role                  = 1       # user
  u.balance               = 5000.0
  u.income                = 2000.0
  u.income_day            = 25
end

# Admin
User.find_or_create_by!(name: "admin") do |u|
  u.password              = "password"
  u.password_confirmation = "password"
  u.role                  = 0       # admin
  u.balance               = 10000.0
  u.income                = 4000.0
  u.income_day            = 1
end

# Viewer
User.find_or_create_by!(name: "viewer") do |u|
  u.password              = "123456789"
  u.password_confirmation = "123456789"
  u.role                  = 2       # viewer
  u.balance               = 1500.0
  u.income                = 1200.0
  u.income_day            = 15
end

# Debug-Admin (Testadmin)
User.find_or_create_by!(name: "testadmin") do |u|
  u.password              = "qwerty"
  u.password_confirmation = "qwerty"
  u.role                  = 0       # admin
  u.balance               = 99999.0
  u.income                = 9999.0
  u.income_day            = 1
end

puts "Seeds successfully loaded:"
puts "   - max       (User,       PW: 123456)"
puts "   - admin     (Admin,      PW: password)"
puts "   - viewer    (Viewer,     PW: 123456789)"
puts "   - testadmin (Debug-Admin PW: qwerty)"