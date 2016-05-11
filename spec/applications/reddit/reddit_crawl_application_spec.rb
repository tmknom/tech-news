require 'rails_helper'

RSpec.describe Reddit::RedditCrawlApplication, type: :application do
  let(:rss_crawl_application) { Reddit::RedditCrawlApplication.new }


  describe '#crawl' do
    it '正常系' do
      # クロール前にデータがないことを確認
      expect(Reddit::RedditArticle.all.size).to eq 0
      expect(Medium.all.size).to eq 0
      # 実行
      url = 'https://www.reddit.com/r/gifs/hot/.rss'
      VCR.use_cassette 'rss/www.reddit.com.gif' do
        rss_crawl_application.crawl url
      end
      # クロール後にデータが登録されたことを確認
      expect(Reddit::RedditArticle.all.size).to eq 26
      expect(Medium.all.size).to eq 26
    end
  end

end
