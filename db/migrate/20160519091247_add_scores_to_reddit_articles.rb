class AddScoresToRedditArticles < ActiveRecord::Migration
  def change
    add_column :reddit_articles, :score, :integer, null: false, default: 0
    add_column :reddit_articles, :comment_count, :integer, null: false, default: 0
    add_column :reddit_articles, :adult, :boolean, null: false, default: false
  end
end
