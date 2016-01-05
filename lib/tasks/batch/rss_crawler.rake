namespace :batch do
  namespace :rss_crawler do
    desc 'はてブのRSSを取得'
    task :crawl => :environment do
      RssCrawlJob.perform_later
    end
  end
end
