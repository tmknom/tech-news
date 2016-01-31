class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci' do |t|
      t.string :url, null: false
      t.string :title, null: false
      t.string :description, null: false
      t.datetime :bookmarked_at, null: false

      t.timestamps null: false
    end
    add_index :articles, :url, unique: true
  end
end
