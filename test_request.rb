require './config/environment'

user = User.create!(name: "TestUserReq#{Time.now.to_i}", password: "password")
app = ActionDispatch::Integration::Session.new(Rails.application)
app.post '/sessions', params: { name: user.name, password: "password" }
app.get '/'
puts app.response.body
