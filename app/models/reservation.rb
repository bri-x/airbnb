class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user
  has_one :payment

  def is_valid?
  	valid_amount?
  	valid_stay?
  	valid_days?
  	return self.errors.blank? ? true : false
  end

  def calculate_days
  	return (self.date_end - self.date_start).to_i
  end

  def confirm
    self.update(paid: true)
  end

  def add_unavailable_dates
    set_listing_dates
    @listing.unavailable_dates += @dates
    begin
      ActiveRecord::Base.transaction do
        @listing.save if @listing.unavailable_dates.uniq.count == @listing.unavailable_dates.count
      end
    rescue Exception => e
      return false
    else
      return true
    end
  end

  def remove_unavailable_dates
    set_listing_dates
    @listing.unavailable_dates -= @dates
    @listing.save
  end

  private

  def valid_amount?
  	errors.add(:listing, 'cannot accomodate all guests') unless self.amount <= self.listing.capacity
  end

  def valid_stay?
  	stay = calculate_days
    errors.add(:listing, "has minimum stay of #{self.listing.min_stay} days") unless stay >= self.listing.min_stay
  end

  def valid_days?
  	if Listing.where("'#{self.date_end}' > ANY (unavailable_dates) AND '#{self.date_end}' <= ANY (unavailable_dates)").any?
      errors.add(:listing, "is not available on those dates") 
    end
  end

  def set_listing_dates
    @listing = self.listing
    @dates = (self.date_start..self.date_end).map { |d| d }
  end
end
