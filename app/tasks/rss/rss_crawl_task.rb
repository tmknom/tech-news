module Rss
  class RssCrawlTask
    def run
      RssCrawlJob.perform_later HATENA_BOOKMARK
    end
  end

  HATENA_BOOKMARK = 'http://b.hatena.ne.jp/entrylist/it?sort=hot&threshold=30&mode=rss'.freeze

end
