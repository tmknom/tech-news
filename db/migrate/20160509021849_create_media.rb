class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :url
      t.string :source_url
      t.string :type

      t.timestamps null: false
    end
    add_index :media, :url
    add_index :media, :source_url
  end
end
