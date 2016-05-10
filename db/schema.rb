# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160508145029) do

  create_table "articles", force: :cascade do |t|
    t.string   "url",           limit: 255, null: false
    t.string   "title",         limit: 255, null: false
    t.string   "description",   limit: 255, null: false
    t.datetime "bookmarked_at",             null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "articles", ["url"], name: "index_articles_on_url", unique: true, using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "article_id",            limit: 4,             null: false
    t.integer  "hatena_bookmark_count", limit: 4, default: 0, null: false
    t.integer  "facebook_count",        limit: 4, default: 0, null: false
    t.integer  "pocket_count",          limit: 4, default: 0, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "ratings", ["article_id"], name: "index_ratings_on_article_id", using: :btree

  create_table "reddit_articles", force: :cascade do |t|
    t.string   "url",         limit: 255, null: false
    t.string   "title",       limit: 255, null: false
    t.string   "media_url",   limit: 255, null: false
    t.string   "description", limit: 255, null: false
    t.datetime "posted_at",               null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "reddit_articles", ["media_url"], name: "index_reddit_articles_on_media_url", unique: true, using: :btree
  add_index "reddit_articles", ["url"], name: "index_reddit_articles_on_url", unique: true, using: :btree

  add_foreign_key "ratings", "articles"
end
