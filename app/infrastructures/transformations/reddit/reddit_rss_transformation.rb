module Reddit
  class RedditRssTransformation
    def transform(rss_item, category)
      title = title(rss_item)
      url = reddit_url(rss_item)
      posted_at = posted_at(rss_item)

      RedditArticle.new(url: url, title: title, category: category, posted_at: posted_at)
    end

    def transform_medium(reddit_article_id, rss_item)
      url = medium_url(rss_item)

      RedditMedium.new(reddit_article_id: reddit_article_id, url: url, media_type: RedditMedium::TYPE_IMAGE)
    end

    private

    def medium_url(rss_item)
      content = rss_item.content.force_encoding('utf-8')
      medium_url = content.match(%r{&lt;span&gt;&lt;a\shref=&quot;(.+?)&quot;&gt;\[link\]})[1]
      medium_url[0, MAX_MYSQL_RECORD_SIZE]
    end

    def reddit_url(rss_item)
      rss_item.link.force_encoding('utf-8')[0, MAX_MYSQL_RECORD_SIZE]
    end

    def title(rss_item)
      rss_item.title.force_encoding('utf-8')[0, MAX_MYSQL_RECORD_SIZE]
    end

    def posted_at(rss_item)
      rss_item.updated # Time型
    end

    MAX_MYSQL_RECORD_SIZE = 255
  end
end
