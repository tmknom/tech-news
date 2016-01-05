require 'rails_helper'

RSpec.describe HatenaBookmarkCountCrawlApplication, type: :application do
  let(:hatena_bookmark_count_crawl_application) { HatenaBookmarkCountCrawlApplication.new }
  let!(:rating) { create(:rating) }

  describe '#crawl' do
    it '正常系' do
      # クロール前のテストデータ確認
      expect(Rating.first.hatena_bookmark_count).to eq rating.hatena_bookmark_count
      # 実行
      allow(hatena_bookmark_count_crawl_application).to receive(:get_hatena_bookmark_count).and_return(999)
      article = Article.find(rating.article_id)
      hatena_bookmark_count_crawl_application.crawl article.url
      # クロール後にデータが更新されたことを確認
      expect(Rating.first.hatena_bookmark_count).to eq 999
    end
  end

end
