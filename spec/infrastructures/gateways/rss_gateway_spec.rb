require 'rails_helper'

RSpec.describe RssGateway, type: :model do

  describe '#get' do
    let!(:rss_gateway) { RssGateway.new }

    it '正常系' do
      url = 'http://b.hatena.ne.jp/entrylist/it?sort=hot&threshold=30&mode=rss'
      VCR.use_cassette 'rss/b.hatena.ne.jp' do
        rss_items = rss_gateway.get url
        expect(rss_items.size).to eq 30
        expect(rss_items[0].title.force_encoding('utf-8')).to eq 'ウェブ関係者よ、PVの話をするのはもう止めよう « WIRED.jp'
        expect(rss_items[0].link.force_encoding('utf-8')).to eq 'http://wired.jp/2016/01/03/page-views-dont-matter/'
        expect(rss_items[0].description.force_encoding('utf-8')).to match /広告主は、無限に続くスライドショーがクリックされるたび/
        expect(rss_items[0].dc_date.in_time_zone('Tokyo')).to eq '2016-01-03 16:31:44 +0900'
      end
    end
  end

end
