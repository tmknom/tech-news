require 'rails_helper'

RSpec.describe Reddit::RedditArticleCommandRepository, type: :model do

  let(:reddit_article_command_repository) { Reddit::RedditArticleCommandRepository.new }

  describe '#save_if_not_exists' do

    it 'DBにデータが存在しないので保存する' do
      new_article = factory_reddit_article('http://new_url.com/')
      reddit_article_command_repository.save_if_not_exists new_article
      expect(Reddit::RedditArticle.first.url).to eq new_article.url
    end

    it 'DBにデータが存在するので更新する' do
      # テストデータ投入
      article = create(:reddit_article)

      # すでにデータが存在することを確認
      expect(Reddit::RedditArticle.first.score).to eq article.score
      expect(Reddit::RedditArticle.first.comment_count).to eq article.comment_count
      expect(Reddit::RedditArticle.first.title).to eq article.title
      expect(Reddit::RedditArticle.all.size).to eq 1

      # URLが同じArticleオブジェクトを保存
      new_article = factory_reddit_article(article.url)
      reddit_article_command_repository.save_if_not_exists new_article

      # データが更新されたことを確認
      expect(Reddit::RedditArticle.first.score).to eq new_article.score
      expect(Reddit::RedditArticle.first.comment_count).to eq new_article.comment_count
      expect(Reddit::RedditArticle.first.title).to eq article.title
      expect(Reddit::RedditArticle.all.size).to eq 1
    end

    def factory_reddit_article(url)
      Reddit::RedditArticle.new(url: url,
                                title: '新しいタイトル',
                                category: Reddit::RedditCategory::GIFS,
                                posted_at: '2015/12/30 12:34:56',
                                score: 10000,
                                comment_count: 1000,
                                adult: true
      )
    end
  end

end
