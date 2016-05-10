module Rss
  class RssTransformation
    def transform(rss_item)
      title = rss_item.title.force_encoding('utf-8')
      url = rss_item.link.force_encoding('utf-8')
      description = rss_item.description.force_encoding('utf-8')
      bookmarked_at = rss_item.dc_date.in_time_zone('Tokyo') # Time型
      Article.new(url: url, title: title, description: description, bookmarked_at: bookmarked_at)
    end
  end
end
