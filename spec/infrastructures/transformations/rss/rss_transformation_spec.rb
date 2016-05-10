require 'rails_helper'

RSpec.describe Rss::RssTransformation, type: :model do

  let(:rss_transformation) { Rss::RssTransformation.new }

  describe '#transform' do
    it '正常系' do

      # インパラをRSSから作成
      rss_items = {}
      url = 'http://b.hatena.ne.jp/entrylist/it?sort=hot&threshold=30&mode=rss'
      VCR.use_cassette 'rss/b.hatena.ne.jp' do
        rss_items = Rss::RssGateway.new.get url
      end

      # 実行
      article = rss_transformation.transform(rss_items[0])

      # 確認
      expect(article.title).to eq 'ウェブ関係者よ、PVの話をするのはもう止めよう « WIRED.jp'
      expect(article.url).to eq 'http://wired.jp/2016/01/03/page-views-dont-matter/'
      expect(article.description).to match /広告主は、無限に続くスライドショーがクリックされるたび/
      expect(article.bookmarked_at).to eq Time.new(2016, 1, 3, 16, 31, 44, '+09:00')
    end
  end

end
