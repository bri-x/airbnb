class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.date :time_start
      t.date :time_end
      t.integer :amount
      t.belongs_to :listing, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
