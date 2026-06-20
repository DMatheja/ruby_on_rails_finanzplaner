# db/seeds.rb

# ---------------------------------------------------------------------------
# Users
# ---------------------------------------------------------------------------

max = User.find_or_create_by!(name: "max") do |u|
  u.password              = "123456"
  u.password_confirmation = "123456"
  u.role                  = 1       # user
  u.balance               = 5000.0
  u.income                = 2000.0
  u.income_day            = 25
end

admin = User.find_or_create_by!(name: "admin") do |u|
  u.password              = "password"
  u.password_confirmation = "password"
  u.role                  = 0       # admin
  u.balance               = 10000.0
  u.income                = 4000.0
  u.income_day            = 1
end

viewer = User.find_or_create_by!(name: "viewer") do |u|
  u.password              = "123456789"
  u.password_confirmation = "123456789"
  u.role                  = 2       # viewer
  u.balance               = 1500.0
  u.income                = 1200.0
  u.income_day            = 15
end

testadmin = User.find_or_create_by!(name: "testadmin") do |u|
  u.password              = "qwerty"
  u.password_confirmation = "qwerty"
  u.role                  = 0       # admin
  u.balance               = 99999.0
  u.income                = 9999.0
  u.income_day            = 1
end

# ---------------------------------------------------------------------------
# Kategorien für "max"
# ---------------------------------------------------------------------------

lebensmittel = Category.find_or_create_by!(name: "Lebensmittel", user: max) do |c|
  c.limit = 400.0
end

freizeit = Category.find_or_create_by!(name: "Freizeit", user: max) do |c|
  c.limit = 150.0
end

wohnen = Category.find_or_create_by!(name: "Wohnen", user: max) do |c|
  c.limit = 900.0
end

# Kategorie für "admin", damit auch dieser Account Daten zum Ausprobieren hat
admin_haushalt = Category.find_or_create_by!(name: "Haushalt", user: admin) do |c|
  c.limit = 300.0
end

# ---------------------------------------------------------------------------
# Produkte (verteilt auf die Kategorien von "max")
# ---------------------------------------------------------------------------

Product.find_or_create_by!(name: "Wocheneinkauf Rewe", category: lebensmittel) do |p|
  p.price  = 64.30
  p.amount = 1
  p.status = "purchased"
end

Product.find_or_create_by!(name: "Bio-Gemüsekiste", category: lebensmittel) do |p|
  p.price  = 22.90
  p.amount = 1
  p.status = "pending"
end

Product.find_or_create_by!(name: "Kinobesuch", category: freizeit) do |p|
  p.price  = 12.50
  p.amount = 2
  p.status = "purchased"
end

Product.find_or_create_by!(name: "Konzertticket", category: freizeit) do |p|
  p.price  = 45.00
  p.amount = 1
  p.status = "pending"
end

Product.find_or_create_by!(name: "Staubsaugerbeutel", category: wohnen) do |p|
  p.price  = 9.99
  p.amount = 1
  p.status = "purchased"
end

Product.find_or_create_by!(name: "Bürostuhl", category: admin_haushalt) do |p|
  p.price  = 129.00
  p.amount = 1
  p.status = "pending"
end

# ---------------------------------------------------------------------------
# Abonnements
# ---------------------------------------------------------------------------

Subscription.find_or_create_by!(name: "Netflix", user: max) do |s|
  s.price             = 12.99
  s.frequency         = "monthly"
  s.billing_day       = 5
  s.start_date        = Date.new(2025, 1, 5)
  s.subscription_type = "platform"
end

Subscription.find_or_create_by!(name: "Spotify", user: max) do |s|
  s.price             = 9.99
  s.frequency         = "monthly"
  s.billing_day       = 15
  s.start_date        = Date.new(2025, 3, 15)
  s.subscription_type = "platform"
end

Subscription.find_or_create_by!(name: "Fitnessstudio", user: max) do |s|
  s.price             = 29.90
  s.frequency         = "monthly"
  s.billing_day       = 1
  s.start_date        = Date.new(2024, 9, 1)
  s.subscription_type = "regular"
  s.quantity          = 1
end

Subscription.find_or_create_by!(name: "Cloud-Speicher", user: admin) do |s|
  s.price             = 2.99
  s.frequency         = "monthly"
  s.billing_day       = 10
  s.start_date        = Date.new(2025, 2, 10)
  s.subscription_type = "platform"
end

Subscription.find_or_create_by!(name: "Disney+", user: max) do |s|
  s.price             = 8.99
  s.frequency         = "monthly"
  s.billing_day       = 20
  s.start_date        = Date.new(2025, 6, 20)
  s.subscription_type = "platform"
end

Subscription.find_or_create_by!(name: "Zeitungsabo", user: max) do |s|
  s.price             = 4.50
  s.frequency         = "weekly"
  s.billing_day       = 1
  s.start_date        = Date.new(2025, 1, 1)
  s.subscription_type = "regular"
  s.quantity          = 1
end

Subscription.find_or_create_by!(name: "Adobe Creative Cloud", user: admin) do |s|
  s.price             = 59.49
  s.frequency         = "monthly"
  s.billing_day       = 1
  s.start_date        = Date.new(2024, 11, 1)
  s.subscription_type = "platform"
end

Subscription.find_or_create_by!(name: "Wasserkasten-Lieferung", user: admin) do |s|
  s.price             = 6.99
  s.frequency         = "weekly"
  s.billing_day       = 3
  s.start_date        = Date.new(2025, 4, 1)
  s.subscription_type = "regular"
  s.quantity          = 2
end

Subscription.find_or_create_by!(name: "Streaming-Paket", user: viewer) do |s|
  s.price             = 17.99
  s.frequency         = "monthly"
  s.billing_day       = 12
  s.start_date        = Date.new(2025, 5, 12)
  s.subscription_type = "platform"
end

# ---------------------------------------------------------------------------
# Ausgabe zur Kontrolle
# ---------------------------------------------------------------------------

puts "Seeds successfully loaded:"
puts "   - max       (User,       PW: 123456)    -> 3 Kategorien, 5 Produkte, 5 Abos"
puts "   - admin     (Admin,      PW: password)  -> 1 Kategorie, 1 Produkt, 3 Abos"
puts "   - viewer    (Viewer,     PW: 123456789) -> 1 Abo"
puts "   - testadmin (Debug-Admin PW: qwerty)     -> keine Beispieldaten"
