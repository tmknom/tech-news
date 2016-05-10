require 'rails_helper'

RSpec.describe Reddit::RedditArticleCommandRepository, type: :model do

  let(:reddit_article_command_repository) { Reddit::RedditArticleCommandRepository.new }

  describe '#save_if_not_exists' do

    it 'DBにデータが存在しないので保存する' do
      new_article = RedditArticle.new(url: 'http://new_url.com/', title: '新しいタイトル', media_url: 'http://new_url.com/example.gif', description: '新しい概要')
      reddit_article_command_repository.save_if_not_exists new_article
      expect(RedditArticle.first.url).to eq new_article.url
    end

    it 'DBにデータが存在するので保存しない' do
      # テストデータ投入
      article = create(:reddit_article)

      # すでにデータが存在することを確認
      expect(RedditArticle.first.title).to eq article.title
      expect(RedditArticle.all.size).to eq 1

      # URLが同じArticleオブジェクトを保存
      new_article = RedditArticle.new(url: article.url, title: '新しいタイトル', media_url: 'http://new_url.com/example.gif', description: '新しい概要')
      reddit_article_command_repository.save_if_not_exists new_article

      # データが保存されていないことを確認
      expect(RedditArticle.first.title).to eq article.title
      expect(RedditArticle.all.size).to eq 1
    end
  end

end
