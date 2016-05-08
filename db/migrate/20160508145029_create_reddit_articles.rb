class CreateRedditArticles < ActiveRecord::Migration
  def change
    create_table :reddit_articles do |t|
      t.string :url
      t.string :title
      t.string :image_url
      t.string :description

      t.timestamps null: false
    end
  end
end
