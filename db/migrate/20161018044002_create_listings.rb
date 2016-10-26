class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :name
      t.text :description
      t.string :property_type
      t.string :room_type
      t.integer :capacity
      t.integer :price
      t.integer :min_stay
      t.string :address
      t.date :unavailable_dates, array: true, default: [], uniqueness: true, index: true

      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end