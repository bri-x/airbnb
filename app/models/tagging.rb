class Tagging < ActiveRecord::Base
	belongs_to :tag
	belongs_to :listing
	after_create :add_tagging_count
	before_destroy :decrease_tagging_count

	private
	def add_tagging_count
		tag = Tag.find(self.tag_id)
		tag.count += 1
		tag.save
	end

	def decrease_tagging_count
		tag = Tag.find(self.tag_id)
		tag.count -= 1
		tag.save
	end
end