# == Schema Information
#
# Table name: reddit_media
#
#  id                :integer          not null, primary key
#  reddit_article_id :integer          not null
#  url               :string(255)      not null
#  media_type        :string(64)       not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  html              :text(65535)      not null
#
# Indexes
#
#  index_reddit_media_on_reddit_article_id  (reddit_article_id)
#
# Foreign Keys
#
#  fk_rails_3fb8eecdb9  (reddit_article_id => reddit_articles.id)
#

FactoryGirl.define do
  factory :reddit_medium, class: Reddit::RedditMedium do
    reddit_article
    sequence(:url) { |i| "https://www.google#{i}.co.jp/example.gif" }
    media_type Reddit::RedditMedium::TYPE_IMAGE
    sequence(:html) { |i| "sample html #{i}" }
  end
end
