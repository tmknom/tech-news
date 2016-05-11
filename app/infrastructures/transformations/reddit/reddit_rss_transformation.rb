module Reddit
  class RedditRssTransformation
    def transform(rss_item)
      title = rss_item.title.force_encoding('utf-8')
      url = reddit_url(rss_item)
      posted_at = rss_item.updated # Time型

      content = rss_item.content.force_encoding('utf-8')
      media_url = media_url(content)
      description = CGI.unescapeHTML(content)[0, 255]

      RedditArticle.new(url: url, title: title, media_url: media_url, description: description, posted_at: posted_at)
    end

    def transform_medium(rss_item)
      content = rss_item.content.force_encoding('utf-8')
      url = media_url(content)
      source_url = reddit_url(rss_item)

      Medium.new(url: url, source_url: source_url, category: Medium::CATEGORY_IMAGE)
    end

    private

    def media_url(content)
      content.match(%r{&lt;span&gt;&lt;a\shref=&quot;(.+?)&quot;&gt;\[link\]})[1]
    end

    def reddit_url(rss_item)
      rss_item.link.force_encoding('utf-8')
    end
  end
end
