namespace :batch do
  namespace :reddit do
    desc 'RedditのRSSを取得'
    task :crawl => :environment do
      Reddit::RedditCrawlTask.new.run
    end
  end
end
