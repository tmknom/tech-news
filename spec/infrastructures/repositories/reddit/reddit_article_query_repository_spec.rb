require 'rails_helper'

RSpec.describe Reddit::RedditArticleQueryRepository, type: :model do

  let(:reddit_article_query_repository) { Reddit::RedditArticleQueryRepository.new }

  describe '#list_today' do
    let!(:reddit_article) do
      create_list(:reddit_article, 3)
    end
    let!(:medium) do
      create_list(:medium, 3)
    end

    it '今日の一覧が取得できること' do
      reddit_article = reddit_article_query_repository.list_today
      expect(reddit_article.size).to eq 3
      expect(reddit_article.first.url).to eq medium.first.url
    end
  end

end
