require 'rails_helper'

RSpec.describe Reddit::RedditArticleQueryRepository, type: :model do

  let(:reddit_article_query_repository) { Reddit::RedditArticleQueryRepository.new }

  describe '#list_recently' do
    let!(:reddit_medium) do
      create_list(:reddit_medium, 3)
    end

    it '一覧が取得できること' do
      articles = reddit_article_query_repository.list_recently(10, nil)
      expect(articles.size).to eq 3
    end
  end

  describe '#list_by_date' do
    let!(:reddit_medium) do
      create_list(:reddit_medium, 3)
    end

    it 'データがある日の一覧が取得できること' do
      articles = reddit_article_query_repository.list_by_date(Date.today, 10, nil)
      expect(articles.size).to eq 3
    end

    it 'データがない日の一覧が取得できるないこと' do
      articles = reddit_article_query_repository.list_by_date(Date.today - 10, 10, nil)
      expect(articles.size).to eq 0
    end
  end

end
