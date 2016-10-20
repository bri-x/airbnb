class RemoveNoGuestFromListings < ActiveRecord::Migration
  def change
    remove_column :listings, :no_guest, :integer
  end
end
