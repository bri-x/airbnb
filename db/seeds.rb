# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

cities = [
{name: 'Kuala Lumpur', country: "Malaysia"}, 
{name: 'London', country: 'UK'},
{name: 'Paris', country: 'France'},
{name: 'Tokyo', country: 'Japan'},
{name: 'New York', country: 'USA'},
{name: 'Rome', country: 'Italy'},
{name: 'Dublin', country: 'Ireland'},
{name: 'Bangkok', country: 'Thailand'},
{name: 'Singapore', country: 'Singapore'},
{name: 'Bali', country: 'Indonesia'},

]

city = City.create(cities)

User.create([{name: "Brigitte", email: "abc@gmail.com", password: "12341234"}, {name: "John Doe", email: "j@doe.com", password: "12341234"}])

18.times do
	User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "12341234")
end

100.times do
	@listing = Listing.new(
		name: Faker::Lorem.sentence,
		description: Faker::Lorem.paragraph,
		property_type: Listing::PROPERTY_TYPES[rand(0..4)],
		room_type: Listing::ROOM_TYPES[rand(0..2)],
		capacity: rand(1..10),
		price: rand(100..5000),
		min_stay: rand(1..5),
		address: Faker::Lorem.word,
		city_id: rand(1..10),
		user_id: rand(1..20)
	)
	@listing.amenity_list = Listing::AMENITIES.sample(rand(1..10))
	@listing.rule_list = Listing::RULES.sample(rand(1..3))
	@listing.save
end