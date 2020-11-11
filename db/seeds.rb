# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
megan.bulk_discounts.create!(bulk_quantity: 5, percentage_discount: 20)
megan.bulk_discounts.create!(bulk_quantity: 10, percentage_discount: 25)

megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )


brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian.bulk_discounts.create!(bulk_quantity: 10, percentage_discount: 30)

brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
brian.items.create!(name: 'Dog', description: "Am Doggo!", price: 100, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 40 )

tim = megan.users.create!(name: "Tim", address: "You hate to see it dr", city: "Denver", state: "CO", zip: 80127, email: "tim@gmail.com", password: "test", role: 1)
alex = megan.users.create!(name: "Alex", address: "Some street", city: "Somewhere in the world", state: "Some state", zip: 80129, email: "alex@gmail.com", password: "test", role: 1)

me = User.create!(name: "Austin Aspaas", address: "7281 south webster st", city: "Littleton", state: "CO", zip: 80128, email: "araspaas@live.com", password: "test", role: 0)
