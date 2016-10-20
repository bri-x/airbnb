class User < ActiveRecord::Base
  include Clearance::User

  mount_uploader :avatar, AvatarUploader

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :password, presence: { on: create }, length: { minimum: 8 }, if: Proc.new { |u| u.authentications.blank? }

  has_many :authentications, :dependent => :destroy
  has_many :listings

  has_many :reservations
  acts_as_booker

  def self.create_with_auth_and_hash(authentication,auth_hash)
    create! do |u|
      u.name = auth_hash["info"]["name"]
      u.email = auth_hash["extra"]["raw_info"]["email"]
      u.authentications<<(authentication)
    end
  end

  def fb_token
    x = self.authentications.where(:provider => :facebook).first
    return x.token unless x.nil?
  end

  def password_optional?
    true
  end
end
