class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :url, null: false
      t.string :title, null: false
      t.string :description, null: false
      t.datetime :bookmarked_at, null: false

      t.timestamps null: false
    end
    add_index :articles, :url, unique: true
  end
end
