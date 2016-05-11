# == Schema Information
#
# Table name: reddit_articles
#
#  id         :integer          not null, primary key
#  url        :string(255)      not null
#  title      :string(255)      not null
#  posted_at  :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reddit_articles_on_url  (url) UNIQUE
#

module Reddit
  class RedditArticle < ActiveRecord::Base
    has_one :reddit_medium, :class_name => 'Reddit::RedditMedium'
  end
end
