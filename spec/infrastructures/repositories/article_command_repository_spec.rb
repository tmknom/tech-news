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

RSpec.describe ArticleCommandRepository, type: :model do

  let(:article_command_repository) { ArticleCommandRepository.new }

  describe '#save_if_not_exists' do

    it 'DBにデータが存在しないので保存する' do
      new_article = Article.new(url: 'http://new_url.com/', title: '新しいタイトル', description: '新しい概要', bookmarked_at: '2015/12/30 12:34:56')
      article_command_repository.save_if_not_exists new_article
      expect(Article.first.url).to eq new_article.url
    end

    it 'DBにデータが存在するので保存しない' do
      # テストデータ投入
      article = create(:article)

      # すでにデータが存在することを確認
      expect(Article.first.title).to eq article.title
      expect(Article.all.size).to eq 1

      # URLが同じArticleオブジェクトを保存
      new_article = Article.new(url: article.url, title: '新しいタイトル', description: '新しい概要', bookmarked_at: '2015/12/30 12:34:56')
      article_command_repository.save_if_not_exists new_article

      # データが保存されていないことを確認
      expect(Article.first.title).to eq article.title
      expect(Article.all.size).to eq 1
    end
  end

end
