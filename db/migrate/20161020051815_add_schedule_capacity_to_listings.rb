class AddScheduleCapacityToListings < ActiveRecord::Migration
  def change
    add_column :listings, :schedule, :text
    add_column :listings, :capacity, :integer
  end
end
