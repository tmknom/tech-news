# == Schema Information
#
# Table name: reddit_media
#
#  id         :integer          not null, primary key
#  url        :string(255)      not null
#  category   :string(64)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RedditMedium < ActiveRecord::Base
end
