class AddHtmlToRedditMedia < ActiveRecord::Migration
  def change
    add_column :reddit_media, :html, :text, null: false
  end
end
