namespace :batch do
  namespace :reddit_crawler do
    desc 'RedditのRSSを取得'
    task :crawl => :environment do
      RedditCrawlTask.new.run
    end
  end
end
