require 'rails_helper'

RSpec.describe Reddit::RedditMediumCommandRepository, type: :model do

  let(:reddit_medium_command_repository) { Reddit::RedditMediumCommandRepository.new }

  describe '#save_if_not_exists' do

    it 'DBにデータが存在しないので保存する' do
      reddit_article = create(:reddit_article)

      # DBに一件もデータがないことを確認
      expect(Reddit::RedditMedium.all.size).to eq 0

      # 実行
      reddit_medium = factory_reddit_medium(reddit_article.id, 'http://new_url.com/')
      reddit_medium_command_repository.save_if_not_exists reddit_medium

      # 確認
      expect(Reddit::RedditMedium.all.size).to eq 1
      expect(Reddit::RedditMedium.first.url).to eq reddit_medium.url
    end

    it 'DBにデータが存在するので保存しない' do
      # テストデータ投入
      reddit_medium = create(:reddit_medium)

      # すでにデータが存在することを確認
      expect(Reddit::RedditMedium.first.url).to eq reddit_medium.url
      expect(Reddit::RedditMedium.all.size).to eq 1

      # 実行
      new_reddit_medium = factory_reddit_medium(reddit_medium.reddit_article_id, reddit_medium.url)
      reddit_medium_command_repository.save_if_not_exists new_reddit_medium

      # データが保存されていないことを確認
      expect(Reddit::RedditMedium.first.url).to eq reddit_medium.url
      expect(Reddit::RedditMedium.all.size).to eq 1
    end
  end

  def factory_reddit_medium(reddit_article_id, url)
    Reddit::RedditMedium.new(reddit_article_id: reddit_article_id,
                             url: url,
                             media_type: Reddit::RedditMedium::TYPE_IMAGE,
                             html: 'sample html'
    )
  end

end
