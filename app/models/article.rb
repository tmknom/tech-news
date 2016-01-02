class Article < ActiveRecord::Base
  def bookmarked_at
    self[:bookmarked_at].in_time_zone('Tokyo')
  end
end
