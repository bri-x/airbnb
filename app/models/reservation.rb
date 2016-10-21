class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user
  has_one :payment

  def total_price
  	price = self.listing.price
  	days = (self.time_end - self.time_start).to_i
  	return price * days
  end
end
