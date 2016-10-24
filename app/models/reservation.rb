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

  def add_to_validities
    id = self.listing_id
    dates = (self.date_start..self.date_end).map { |d| d }
    dates.pop
    begin
      ActiveRecord::Base.transaction do
        dates.each do
         |d| Validity.create!(listing_id: id, date: d )
        end
      end
    rescue Exception => e
      return false
    else
      return true
    end
  end

  def remove_validities
    Validity.where("date >= ? AND date < ? AND listing_id = ? ", self.date_start, self.date_end, self.listing_id).destroy_all
  end

  private

  def valid_amount?
  	if self.amount > self.listing.capacity
  		self.errors[:listing] << " cannot accomodate all guests"
  	end
  end

  def valid_stay?
  	stay = calculate_days
  	if stay < self.listing.min_stay
  		self.errors[:listing] << "has minimum stay of #{self.listing.min_stay} days"
  	end
  end

  def valid_days?
  	result = Validity.where("date >= ? AND date < ? AND listing_id = ? ", self.date_start, self.date_end, self.listing_id)
  	if result.any?
  		self.errors[:listing] << "is not available on those dates"
  	end
  end
end
