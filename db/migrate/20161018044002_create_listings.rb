class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :name
      t.text :description
      t.string :property_type
      t.string :room_type
      t.integer :no_guest
      t.integer :price
      t.integer :min_stay
      t.string :address
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end