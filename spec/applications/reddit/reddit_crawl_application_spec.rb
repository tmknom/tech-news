require 'rails_helper'

RSpec.describe Reddit::RedditCrawlApplication, type: :application do
  let(:rss_crawl_application) { Reddit::RedditCrawlApplication.new }


  describe '#crawl' do
    it '正常系' do
      # クロール前にデータがないことを確認
      expect(Reddit::RedditArticle.all.size).to eq 0
      expect(Reddit::RedditMedium.all.size).to eq 0
      # 実行
      VCR.use_cassette 'reddit/www.reddit.com' do
        rss_crawl_application.crawl Reddit::RedditCategory::GIFS
      end
      # クロール後にデータが登録されたことを確認
      expect(Reddit::RedditArticle.all.size).to eq 11
      expect(Reddit::RedditMedium.all.size).to eq 9
    end
  end

end
