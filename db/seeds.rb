# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#merchants
mike = Merchant.create(name: "Mike\'s Mustache Emporium", address: '127 Main St', city: 'Denver', state: 'CO', zip: 80218)
megan = Merchant.create(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

#users
admin = User.create(name: "Admin User", address: "321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "admin@example.com", password: "password_admin", role: 2)
user_mike = mike.users.create(name: 'Mike Dao', address: '127 Main St', city: 'Denver', state: 'CO', zip: 80218, email: "merchant@example.com", password: "password_merchant", role: 1)
user1 = User.create(name: 'Jesse Gietzen', address: '461 Ammo Dr', city: 'Boomtown', state: 'CO', zip: 80461, email: "user@example.com", password: "password_regular")

#items
megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

#discounts
discount1 = mike.discounts.create(percentage: 5, item_count: 5, active: true)
