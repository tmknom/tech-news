module Reddit
  class RedditRssTransformation
    def transform(rss_item)
      title = rss_item.title.force_encoding('utf-8')
      url = rss_item.link.force_encoding('utf-8')
      media_url = url + '/dummy.gif'
      description = CGI.unescapeHTML(rss_item.content.force_encoding('utf-8'))[0, 255]
      posted_at = rss_item.updated.in_time_zone('Tokyo') # Time型
      RedditArticle.new(url: url, title: title, media_url: media_url, description: description, posted_at: posted_at)
    end
  end
end
