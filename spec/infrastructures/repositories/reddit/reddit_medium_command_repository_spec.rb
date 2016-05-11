require 'rails_helper'

RSpec.describe Reddit::RedditMediumCommandRepository, type: :model do

  let(:reddit_medium_command_repository) { Reddit::RedditMediumCommandRepository.new }

  describe '#save' do

    it 'DBにデータが存在しないので保存する' do
      reddit_medium = RedditMedium.new(url: 'http://new_url.com/', category: RedditMedium::CATEGORY_IMAGE)
      reddit_medium_command_repository.save reddit_medium
      expect(RedditMedium.first.url).to eq reddit_medium.url
    end

    # it 'DBにデータが存在するので保存しない' do
    it 'DBにデータが存在するけど保存する' do
      # テストデータ投入
      reddit_medium = create(:reddit_medium)

      # すでにデータが存在することを確認
      expect(RedditMedium.first.url).to eq reddit_medium.url
      expect(RedditMedium.all.size).to eq 1

      # 実行
      new_reddit_medium = RedditMedium.new(url: reddit_medium.url, category: RedditMedium::CATEGORY_IMAGE)
      reddit_medium_command_repository.save new_reddit_medium

      # データが保存されていないことを確認
      expect(RedditMedium.first.url).to eq reddit_medium.url
      expect(RedditMedium.all.size).to eq 2
    end
  end

end
