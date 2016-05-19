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

module Reddit
  class RedditMedium < ActiveRecord::Base
    belongs_to :reddit_article, :class_name => 'Reddit::RedditArticle'

    TYPE_IMAGE = 'image'.freeze
  end
end
