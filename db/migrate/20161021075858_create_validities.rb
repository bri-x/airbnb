class CreateValidities < ActiveRecord::Migration
  def change
    create_table :validities do |t|
    	t.references :listing
    	t.date :date

      t.timestamps null: false
    end

    add_index :validities, [:date, :listing_id], :unique => true
  end
end
