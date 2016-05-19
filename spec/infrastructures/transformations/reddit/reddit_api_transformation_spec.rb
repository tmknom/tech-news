require 'rails_helper'

RSpec.describe Reddit::RedditRssTransformation, type: :model do

  let(:reddit_rss_transformation) { Reddit::RedditApiTransformation.new }

  describe '#transform' do
    it '正常系' do

      # インパラをAPIから作成
      items = {}
      VCR.use_cassette 'reddit/www.reddit.com' do
        items = Reddit::RedditExtraction.new.extract('gifs')
      end

      # 実行
      reddit_article = reddit_rss_transformation.transform(items[1], Reddit::RedditCategory::GIFS)

      # 確認
      expect(reddit_article.title).to eq 'That pizza must be delicious'
      expect(reddit_article.url).to eq 'https://www.reddit.com/r/gifs/comments/4jzrka/that_pizza_must_be_delicious/'
      expect(reddit_article.category).to eq Reddit::RedditCategory::GIFS
      expect(reddit_article.posted_at).to eq Time.utc(2016, 5, 19, 0, 4, 16)
    end
  end

  describe '#transform_medium' do
    it '正常系' do

      # インパラをAPIから作成
      items = {}
      VCR.use_cassette 'reddit/www.reddit.com' do
        items = Reddit::RedditExtraction.new.extract('gifs')
      end

      # 実行
      reddit_article_id = 1
      reddit_medium = reddit_rss_transformation.transform_medium(reddit_article_id, items[1])

      # 確認
      expect(reddit_medium.url).to eq 'http://imgur.com/MV42hYt.gifv'
      expect(reddit_medium.media_type).to eq 'image'
    end
  end

end
