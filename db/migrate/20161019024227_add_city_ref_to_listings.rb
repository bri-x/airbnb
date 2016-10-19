class AddCityRefToListings < ActiveRecord::Migration
  def change
    add_reference :listings, :city, index: true, foreign_key: true
  end
end
