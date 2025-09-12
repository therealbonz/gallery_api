class CreateMediaItems < ActiveRecord::Migration[8.0]
  def change
    create_table :media_items do |t|
      t.string :title
      t.text :description
      t.string :media_type
      t.integer :position
      t.references :user, null: true, foreign_key: true
      t.integer :likes_count

      t.timestamps
    end
  end
end
