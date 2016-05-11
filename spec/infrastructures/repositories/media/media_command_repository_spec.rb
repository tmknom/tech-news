require 'rails_helper'

RSpec.describe Media::MediaCommandRepository, type: :model do

  let(:medium_command_repository) { Media::MediaCommandRepository.new }

  describe '#save_if_not_exists' do

    it 'DBにデータが存在しないので保存する' do
      medium = Medium.new(url: 'http://new_url.com/', source_url: 'http://new_source_url.com/', category: Medium::CATEGORY_IMAGE)
      medium_command_repository.save_if_not_exists medium
      expect(Medium.first.url).to eq medium.url
    end

    it 'DBにデータが存在するので保存しない' do
      # テストデータ投入
      medium = create(:medium)

      # すでにデータが存在することを確認
      expect(Medium.first.url).to eq medium.url
      expect(Medium.all.size).to eq 1

      # 実行
      new_medium = Medium.new(url: medium.url, source_url: medium.source_url, category: Medium::CATEGORY_IMAGE)
      medium_command_repository.save_if_not_exists new_medium

      # データが保存されていないことを確認
      expect(Medium.first.url).to eq medium.url
      expect(Medium.all.size).to eq 1
    end
  end

end
