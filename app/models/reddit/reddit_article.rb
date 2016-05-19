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

module Reddit
  class RedditArticle < ActiveRecord::Base
    has_one :reddit_medium, :class_name => 'Reddit::RedditMedium'

    def created_at
      self[:created_at].in_time_zone('Tokyo').strftime('%Y/%m/%d %H:%M')
    end
  end
end
