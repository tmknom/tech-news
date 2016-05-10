namespace :batch do
  namespace :rss do
    desc 'はてブ数を取得'
    task :hatena_bookmark_count_crawl => :environment do
      Rss::HatenaBookmarkCountCrawlTask.new.run
    end

    desc 'イイネ数を取得'
    task :facebook_count_crawl => :environment do
      Rss::FacebookCountCrawlTask.new.run
    end
  end
end
