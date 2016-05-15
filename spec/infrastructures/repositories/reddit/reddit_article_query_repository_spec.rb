require 'rails_helper'

RSpec.describe Reddit::RedditArticleQueryRepository, type: :model do

  let(:reddit_article_query_repository) { Reddit::RedditArticleQueryRepository.new }

  describe '#list_recently' do
    let!(:reddit_medium) do
      create_list(:reddit_medium, 3)
    end

    it '一覧が取得できること' do
      articles = reddit_article_query_repository.list_recently nil
      expect(articles.size).to eq 3
    end
  end

end
