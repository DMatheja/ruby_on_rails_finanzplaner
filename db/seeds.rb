# db/seeds.rb

# User
User.find_or_create_by!(name: "max") do |u|
  u.password              = "passwort123"
  u.password_confirmation = "passwort123"
  u.role                  = 1       # user
  u.balance               = 5000.0
  u.income                = 2000.0
  u.income_day            = 25
end

# Admin
User.find_or_create_by!(name: "admin") do |u|
  u.password              = "admin123"
  u.password_confirmation = "admin123"
  u.role                  = 0       # admin
  u.balance               = 10000.0
  u.income                = 4000.0
  u.income_day            = 1
end

# Viewer
User.find_or_create_by!(name: "viewer") do |u|
  u.password              = "viewer123"
  u.password_confirmation = "viewer123"
  u.role                  = 2       # viewer
  u.balance               = 1500.0
  u.income                = 1200.0
  u.income_day            = 15
end

# Debug-Admin (Testadmin)
User.find_or_create_by!(name: "testadmin") do |u|
  u.password              = "debug123"
  u.password_confirmation = "debug123"
  u.role                  = 0       # admin
  u.balance               = 99999.0
  u.income                = 9999.0
  u.income_day            = 1
end

puts "Seeds successfully loaded:"
puts "   - max       (User,       PW: passwort123)"
puts "   - admin     (Admin,      PW: admin123)"
puts "   - viewer    (Viewer,     PW: viewer123)"
puts "   - testadmin (Debug-Admin PW: debug123)"