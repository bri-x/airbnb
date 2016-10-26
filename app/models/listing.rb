class Listing < ActiveRecord::Base
	include Filterable

	# constants
	AMENITIES = ["Essentials", "Towels", "Soap", "Toilet paper", "Wifi", "TV", "Heat", "Air conditioning", "Breakfast, coffee, tea", "Workspace", "Iron", "Hair dryer"]
	RULES = ["Smoking", "Pets", "House party"]
	PROPERTY_TYPES = ['Apartment', 'House', 'Cabin', 'Villa', 'Castle']
	ROOM_TYPES = ['Entire place', 'Private room', 'Shared room']
	RANGES = ["100", "100-250", "250-500", "500-1000", "1000-2500", ">2500"]

	# scopes
	scope :location, ->(q) { includes(:city).where('cities.name ILIKE :query OR cities.country ILIKE :query', query: q).references(:cities) }
	scope :price, -> (ranges) { where(price: ranges) }
	scope :date, ->(dates) { where.not("'#{dates[:start]}' > ANY (unavailable_dates) AND '#{dates[:end]}' <= ANY (unavailable_dates)").where("min_stay <= ?", (Date.parse(date[:end]) - Date.parse(date[:start])).to_i) }
	scope :capacity, ->(q) { where(capacity: q)}
	scope :property_type, ->(types) { where(property_type: types) }
	scope :room_type, ->(types) { where(room_type: types) }
	
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
