namespace :batch do
  namespace :rating_crawler do
    desc 'はてブ数を取得'
    task :hatena_bookmark_count_crawl => :environment do
      HatenaBookmarkCountCrawlTask.new.run
    end

    desc 'イイネ数を取得'
    task :facebook_count_crawl => :environment do
      FacebookCountCrawlTask.new.run
    end
  end
end
