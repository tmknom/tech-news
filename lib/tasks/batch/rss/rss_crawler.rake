namespace :batch do
  namespace :rss do
    desc 'はてブのRSSを取得'
    task :crawl => :environment do
      RssCrawlTask.new.run
    end
  end
end
