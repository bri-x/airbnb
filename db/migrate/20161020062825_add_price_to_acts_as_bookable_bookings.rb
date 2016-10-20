class AddPriceToActsAsBookableBookings < ActiveRecord::Migration
  def change
    add_column :acts_as_bookable_bookings, :price, :integer
  end
end
