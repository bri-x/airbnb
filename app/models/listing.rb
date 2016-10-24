class Listing < ActiveRecord::Base

	# constants
	AMENITIES = ["Essentials", "Towels", "Soap", "Toilet paper", "Wifi", "TV", "Heat", "Air conditioning", "Breakfast, coffee, tea", "Workspace", "Iron", "Hair dryer"]

	RULES = ["Smoking", "Pets", "House party"]

	PROPERTY_TYPES = ['Apartment', 'House', 'Cabin', 'Villa', 'Castle']
	ROOM_TYPES = ['Entire place', 'Private room', 'Shared room']

	# callbacks
	after_save :update_tags

	# validations
	validates :name, :property_type, :room_type, :price, :min_stay, :address, :capacity, presence: true

	# relations
	belongs_to :user
	belongs_to :city
	
	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings
	
	mount_uploaders :photos, PhotoUploader

	has_many :reservations
	has_many :validities
	
	attr_writer :amenity_list
	attr_writer :rule_list

	def amenity_list
		if @amenity_list
			return @amenity_list
		else
			return self.taggings.where(context: "amenity").joins(:tag).pluck(:name)
		end
	end

	def rule_list
		if @rule_list
			return @rule_list
		else
			return self.taggings.where(context: "rule").joins(:tag).pluck(:name)
		end
	end

	private
	def update_tags
		self.taggings.destroy_all
		if @amenity_list
			@amenity_list.each do |a|
			tag = Tag.find_or_create_by(name: a)
      tagging = self.taggings.create(tag_id: tag.id, context: "amenity")
    	end
    end
    if @rule_list
	    @rule_list.each do |a|
				tag = Tag.find_or_create_by(name: a)
	      tagging = self.taggings.create(tag_id: tag.id, context: "rule")
	    end
	  end
	end
end
