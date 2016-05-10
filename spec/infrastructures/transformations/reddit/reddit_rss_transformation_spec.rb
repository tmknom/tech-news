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
      reddit_article = reddit_rss_transformation.transform(rss_items[0])

      # 確認
      expect(reddit_article.title).to eq '/r/Gifs rules: Please read before submitting or commenting'
      expect(reddit_article.url).to eq 'https://www.reddit.com/r/gifs/comments/3dasau/rgifs_rules_please_read_before_submitting_or/'
      expect(reddit_article.media_url).to eq reddit_article.url + 'dummy.gif'
      expect(reddit_article.description).to eq "<!-- SC_OFF --><div class=\"md\"><h1><a href=\"/wiki/reddit_101\">New to reddit? Click here!</a></h1> <h1><strong>.gif, .gifv, .ogg, .mp4, and .webm format submissions only, please!</strong></h1> <h1><strong>Submissions cannot contain sound</strong></h1> <p><"
      expect(reddit_article.posted_at).to eq Time.utc(2015, 7, 14, 20, 49, 54)
    end
  end

end
