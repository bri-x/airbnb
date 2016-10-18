class Listing < ActiveRecord::Base
	AMENITIES = ["Essentials", "Towels", "Soap", "Toilet paper", "Wifi", "TV", "Heat", "Air conditioning", "Breakfast, coffee, tea", "Workspace", "Iron", "Hair dryer"]

	RULES = ["Smoking", "Pets", "House party"]

	PROPERTY_TYPES = ['Apartment', 'House', 'Cabin', 'Villa', 'Castle']
	ROOM_TYPES = ['Entire place', 'Private room', 'Shared room']

	belongs_to :host, class_name: "User"
	validates :name, :property_type, :room_type, :no_guest, :price, :min_stay, :address, presence: true
	acts_as_taggable_on :rules, :amenities
end
