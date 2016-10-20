class Photo < ActiveRecord::Base
	mount_uploaders :avatar, AvatarUploader
	belongs_to :listing
end
