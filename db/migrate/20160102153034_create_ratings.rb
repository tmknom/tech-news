class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :article, index: true, foreign_key: true
      t.integer :hatena_bookmark_count
      t.integer :facebook_count
      t.integer :pocket_count

      t.timestamps null: false
    end
  end
end
