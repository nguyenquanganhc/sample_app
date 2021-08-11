# Create a main sample user.
User.create!  name: "Quang Anh",
              email: "quanganhk62@gmail.com",
              password:"quanganh906",
              password_confirmation: "quanganh906",
              admin: true,
              activated: true, 
              activated_at: Time.zone.now

  # Generate a bunch of additional users.
49.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "password"
  User.create!  name: name,
                email: email,
                password: password,
                password_confirmation: password,
                activated: true, 
                activated_at: Time.zone.now
end

users = User.order(:created_at).take(6)
30.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end
