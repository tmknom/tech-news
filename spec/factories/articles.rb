# == Schema Information
#
# Table name: articles
#
#  id            :integer          not null, primary key
#  url           :string(255)      not null
#  title         :string(255)      not null
#  description   :string(255)      not null
#  bookmarked_at :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_articles_on_url  (url) UNIQUE
#

FactoryGirl.define do
  factory :article do
    sequence(:url) { |i| "https://www.google#{i}.co.jp/" }
    sequence(:title) { |i| "Google#{i}" }
    sequence(:description) { |i| "検索エンジンだよ#{i}" }
    bookmark_date_time '2015/12/30 12:34:56'
  end
end
