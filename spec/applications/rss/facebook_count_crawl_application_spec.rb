require 'rails_helper'

RSpec.describe Rss::FacebookCountCrawlApplication, type: :application do
  let(:facebook_count_crawl_application) { Rss::FacebookCountCrawlApplication.new }
  let!(:rating) { create(:rating) }

  describe '#crawl' do
    it '正常系' do
      # クロール前のテストデータ確認
      expect(Rating.first.facebook_count).to eq rating.facebook_count
      # 実行
      allow(facebook_count_crawl_application).to receive(:get_facebook_count).and_return(999)
      facebook_count_crawl_application.crawl rating.article_id
      # クロール後にデータが更新されたことを確認
      expect(Rating.first.facebook_count).to eq 999
    end
  end

end
