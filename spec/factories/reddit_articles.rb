# == Schema Information
#
# Table name: reddit_articles
#
#  id          :integer          not null, primary key
#  url         :string(255)      not null
#  title       :string(255)      not null
#  media_url   :string(255)      not null
#  description :string(255)      not null
#  posted_at   :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_reddit_articles_on_media_url  (media_url) UNIQUE
#  index_reddit_articles_on_url        (url) UNIQUE
#

FactoryGirl.define do
  factory :reddit_article do
    sequence(:url) { |i| "https://www.google#{i}.co.jp/" }
    sequence(:title) { |i| "Google#{i}" }
    sequence(:media_url) { |i| "https://www.google#{i}.co.jp/example.gif" }
    sequence(:description) { |i| "検索エンジンだよ#{i}" }
    posted_at '2015/12/30 12:34:56'
  end
end
