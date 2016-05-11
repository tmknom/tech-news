class CreateRedditMedia < ActiveRecord::Migration
  def change
    create_table :reddit_media do |t|
      t.string :url
      t.string :category

      t.timestamps null: false
    end
  end
end
