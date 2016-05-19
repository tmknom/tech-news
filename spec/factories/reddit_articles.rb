# == Schema Information
#
# Table name: reddit_articles
#
#  id            :integer          not null, primary key
#  url           :string(255)      not null
#  title         :string(255)      not null
#  category      :string(255)      not null
#  posted_at     :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  score         :integer          default(0), not null
#  comment_count :integer          default(0), not null
#  adult         :boolean          default(FALSE), not null
#
# Indexes
#
#  index_reddit_articles_on_url  (url) UNIQUE
#

FactoryGirl.define do
  factory :reddit_article, class: Reddit::RedditArticle do
    sequence(:url) { |i| "https://www.google#{i}.co.jp/" }
    sequence(:title) { |i| "Google#{i}" }
    category Reddit::RedditCategory::GIFS
    posted_at '2015/12/30 12:34:56'
    sequence(:score) { |i| i + 1000 }
    sequence(:comment_count) { |i| i + 100 }
    adult false
  end
end
