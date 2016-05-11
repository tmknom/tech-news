module Reddit
  class RedditRssTransformation
    def transform(rss_item)
      title = rss_item.title.force_encoding('utf-8')
      url = rss_item.link.force_encoding('utf-8')
      posted_at = rss_item.updated # Time型

      content = rss_item.content.force_encoding('utf-8')
      media_url = parse_media_url(content)
      description = CGI.unescapeHTML(content)[0, 255]

      RedditArticle.new(url: url, title: title, media_url: media_url, description: description, posted_at: posted_at)
    end

    private

    def parse_media_url(content)
      content.match(%r{&lt;span&gt;&lt;a\shref=&quot;(.+?)&quot;&gt;\[link\]})[1]
    end
  end
end
