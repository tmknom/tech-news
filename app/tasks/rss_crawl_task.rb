class RssCrawlTask
  def run
    RssCrawlJob.perform_later RssUrl::HATENA_BOOKMARK
  end
end

module RssUrl
  HATENA_BOOKMARK = 'http://b.hatena.ne.jp/entrylist/it?sort=hot&threshold=30&mode=rss'.freeze
end
