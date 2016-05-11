class CreateRedditMedia < ActiveRecord::Migration
  def change
    create_table :reddit_media do |t|
      t.string :url, null: false
      t.string :category, null: false, limit: 64

      t.timestamps null: false
    end
  end
end
