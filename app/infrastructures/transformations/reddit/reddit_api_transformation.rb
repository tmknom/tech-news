module Reddit
  class RedditApiTransformation
    REDDIT_URL = 'https://www.reddit.com'.freeze

    def transform(item, category)
      title = title(item)
      url = reddit_url(item)
      posted_at = posted_at(item)

      RedditArticle.new(url: url, title: title, category: category, posted_at: posted_at)
    end

    def transform_medium(reddit_article_id, item)
      url = medium_url(item)

      RedditMedium.new(reddit_article_id: reddit_article_id, url: url, media_type: RedditMedium::TYPE_IMAGE)
    end

    private

    def medium_url(item)
      item.url.force_encoding('utf-8')[0, MAX_MYSQL_RECORD_SIZE]
    end

    def reddit_url(item)
      REDDIT_URL + item.permalink.force_encoding('utf-8')[0, MAX_MYSQL_RECORD_SIZE]
    end

    def title(item)
      item.title.force_encoding('utf-8')[0, MAX_MYSQL_RECORD_SIZE]
    end

    def posted_at(item)
      Time.at(item.created_utc) # Time型 1414767600)
    end

    MAX_MYSQL_RECORD_SIZE = 255
  end
end
