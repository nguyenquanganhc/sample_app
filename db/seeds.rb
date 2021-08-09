# Create a main sample user.
User.create!  name: "Quang Anh",
              email: "quanganhk62@gmail.com",
              password:"quanganh906",
              password_confirmation: "quanganh906",
              admin: true

  # Generate a bunch of additional users.
49.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "password"
  User.create!  name: name,
                email: email,
                password: password,
                password_confirmation: password
end
