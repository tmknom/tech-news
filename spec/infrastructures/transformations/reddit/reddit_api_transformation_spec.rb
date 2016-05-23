require 'rails_helper'

RSpec.describe Reddit::RedditApiTransformation, type: :model do

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
      expect(reddit_article.title).to eq 'That pizza must be delicious:sob:'
      expect(reddit_article.url).to eq 'https://www.reddit.com/r/gifs/comments/4jzrka/that_pizza_must_be_delicious/'
      expect(reddit_article.category).to eq Reddit::RedditCategory::GIFS
      expect(reddit_article.posted_at).to eq Time.utc(2016, 5, 19, 0, 4, 16)
      expect(reddit_article.score).to eq 4723
      expect(reddit_article.comment_count).to eq 391
      expect(reddit_article.adult).to eq false
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
      expect(reddit_medium.reddit_article_id).to eq reddit_article_id
      expect(reddit_medium.url).to eq 'http://imgur.com/MV42hYt.gifv'
      expect(reddit_medium.media_type).to eq 'image'
      expect(reddit_medium.html).to eq '<iframe class="embedly-embed" src="https://cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fi.imgur.com%2FMV42hYt.mp4&src_secure=1&url=http%3A%2F%2Fi.imgur.com%2FMV42hYt.gifv&image=https%3A%2F%2Fi.imgur.com%2FMV42hYth.jpg&key=2aa3c4d5f3de4f5b9120b660ad850dc9&type=video%2Fmp4&schema=imgur" width="406" height="720" scrolling="no" frameborder="0" allowfullscreen></iframe>'
    end
  end

end
