class CreateRedditMedia < ActiveRecord::Migration
  def change
    create_table :reddit_media do |t|
      t.references :reddit_article, null: false, index: true, foreign_key: true
      t.string :url, null: false
      t.string :media_type, null: false, limit: 64

      t.timestamps null: false
    end
  end
end
