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

require 'rails_helper'

RSpec.describe ArticleQueryRepository, type: :model do

  let(:article_query_repository) { ArticleQueryRepository.new }

  describe '#refer' do
    let!(:article) { create(:article) }

    it '存在するデータ' do
      actual = article_query_repository.refer article.id
      expect(article.url).to eq actual.url
    end

    it '存在しないデータ' do
      expect { article_query_repository.refer 'invalid_id' }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#get_id_by_url' do
    let!(:article) { create(:article) }

    it '存在するデータ' do
      id = article_query_repository.get_id_by_url article.url
      expect(id).to eq article.id
    end

    it '存在しないデータ' do
      expect { article_query_repository.get_id_by_url 'invalid_url' }.to raise_error(NoMethodError)
    end
  end

  describe '#list_recent_id' do
    let!(:ratings) do
      create_list(:rating, 3)
    end

    it '最新のid一覧が取得できること' do
      ids = article_query_repository.list_recent_id
      expect(ids.size).to eq 3
    end
  end

end
