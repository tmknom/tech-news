class CreateRedditArticles < ActiveRecord::Migration
  def change
    create_table :reddit_articles do |t|
      t.string :url, null: false
      t.string :title, null: false
      t.string :category, null: false
      t.datetime :posted_at, null: false

      t.timestamps null: false
    end
    add_index :reddit_articles, :url, unique: true
  end
end
