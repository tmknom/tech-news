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

RSpec.describe Rss::ArticleQueryRepository, type: :model do

  let(:article_query_repository) { Rss::ArticleQueryRepository.new }

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

  describe '#list_today' do
    let!(:ratings) do
      create_list(:rating, 3)
    end

    it '今日の一覧が取得できること' do
      article = article_query_repository.list_today
      expect(article.size).to eq 3
    end
  end

  describe '#list_week' do
    let!(:ratings) do
      create_list(:rating, 3)
    end

    it '今週の一覧が取得できること' do
      article = article_query_repository.list_week
      expect(article.size).to eq 3
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
