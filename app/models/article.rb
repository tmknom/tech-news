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

class Article < ActiveRecord::Base
  has_one :rating

  def bookmarked_at
    self[:bookmarked_at].in_time_zone('Tokyo')
  end
end
