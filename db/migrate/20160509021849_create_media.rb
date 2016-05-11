class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :url, null: false
      t.string :source_url, null: false
      t.string :category, null: false, limit: 64

      t.timestamps null: false
    end
    add_index :media, :url
    add_index :media, :source_url
  end
end
