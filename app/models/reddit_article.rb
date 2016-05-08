# == Schema Information
#
# Table name: reddit_articles
#
#  id          :integer          not null, primary key
#  url         :string(255)      not null
#  title       :string(255)      not null
#  image_url   :string(255)      not null
#  description :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_reddit_articles_on_url  (url) UNIQUE
#

class RedditArticle < ActiveRecord::Base
end
