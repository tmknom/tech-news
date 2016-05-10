require 'rails_helper'

RSpec.describe Rss::RssCrawlApplication, type: :application do
  let(:rss_crawl_application) { Rss::RssCrawlApplication.new }


  describe '#crawl' do
    it '正常系' do
      # クロール前にデータがないことを確認
      expect(Article.all.size).to eq 0
      expect(Rating.all.size).to eq 0
      # 実行
      url = 'http://b.hatena.ne.jp/entrylist/it?sort=hot&threshold=30&mode=rss'
      VCR.use_cassette 'rss/b.hatena.ne.jp' do
        rss_crawl_application.crawl url
      end
      # クロール後にデータが登録されたことを確認
      expect(Article.all.size).to eq 30
      expect(Rating.all.size).to eq 30
    end
  end

end
