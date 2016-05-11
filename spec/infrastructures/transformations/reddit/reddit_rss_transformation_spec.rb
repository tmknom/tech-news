require 'rails_helper'

RSpec.describe Reddit::RedditRssTransformation, type: :model do

  let(:reddit_rss_transformation) { Reddit::RedditRssTransformation.new }

  describe '#transform' do
    it '正常系' do

      # インパラをRSSから作成
      rss_items = {}
      url = 'https://www.reddit.com/r/gifs/hot/.rss'
      VCR.use_cassette 'rss/www.reddit.com.gif' do
        rss_items = Rss::RssGateway.new.get url
      end

      # 実行
      reddit_article = reddit_rss_transformation.transform(rss_items[1])

      # 確認
      expect(reddit_article.title).to eq 'For everyone who wanted to see the actual demolition'
      expect(reddit_article.url).to eq 'https://www.reddit.com/r/gifs/comments/4ilapw/for_everyone_who_wanted_to_see_the_actual/'
      expect(reddit_article.media_url).to eq 'http://i.imgur.com/QGbGlAf.gifv'
      expect(reddit_article.description).to eq "<table> <tr><td> <a href=\"https://www.reddit.com/r/gifs/comments/4ilapw/for_everyone_who_wanted_to_see_the_actual/\"> <img src=\"https://a.thumbs.redditmedia.com/cUNksnQE4ysj-huLqGFsgGZhiAXYutsj1QKJ3dNn6B8.jpg\" alt=\"For everyone who wanted to see the actual"
      expect(reddit_article.posted_at).to eq Time.utc(2016, 5, 9, 19, 39, 21)
    end
  end

end
