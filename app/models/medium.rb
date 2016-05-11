# == Schema Information
#
# Table name: media
#
#  id         :integer          not null, primary key
#  url        :string(255)      not null
#  source_url :string(255)      not null
#  type       :string(64)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_media_on_source_url  (source_url)
#  index_media_on_url         (url)
#

class Medium < ActiveRecord::Base
end
