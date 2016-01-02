class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :article, null: false, index: true, foreign_key: true
      t.integer :hatena_bookmark_count, null: false, default: 0
      t.integer :facebook_count, null: false, default: 0
      t.integer :pocket_count, null: false, default: 0

      t.timestamps null: false
    end
  end
end
