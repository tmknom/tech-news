namespace :batch do
  namespace :rss_crawler do
    desc 'はてブのRSSを取得'
    task :crawl => :environment do
      RssCrawlTask.new.run
    end
  end
end
