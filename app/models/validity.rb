class Validity < ActiveRecord::Base
	validates_uniqueness_of :listing_id, :scope => :date

	belongs_to :listing
end
