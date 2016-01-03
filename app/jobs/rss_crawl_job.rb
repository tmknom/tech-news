class RssCrawlJob < ActiveJob::Base
  queue_as :default

  HATENA_BOOKMARK_RSS_URL = 'http://b.hatena.ne.jp/entrylist/it?sort=hot&threshold=30&mode=rss'.freeze

  # RssCrawlJob.perform_later
  def perform
    p "start #{self.class}"
    RssCrawlApplication.new.crawl HATENA_BOOKMARK_RSS_URL
    p "end #{self.class}"
  end
end
