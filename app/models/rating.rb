# == Schema Information
#
# Table name: ratings
#
#  id                    :integer          not null, primary key
#  article_id            :integer          not null
#  hatena_bookmark_count :integer          default(0), not null
#  facebook_count        :integer          default(0), not null
#  pocket_count          :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_ratings_on_article_id  (article_id)
#
# Foreign Keys
#
#  fk_rails_e25201a524  (article_id => articles.id)
#

class Rating < ActiveRecord::Base
  belongs_to :article
end
