class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :tag, index: true, foreign_key: true
      t.references :listing, index: true, foreign_key: true
      t.string :context
    end

    add_index :taggings, [:tag_id, :context]
  end
end
