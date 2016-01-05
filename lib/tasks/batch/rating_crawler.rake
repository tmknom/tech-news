namespace :batch do
  namespace :rating_crawler do
    desc 'はてブ数を取得'
    task :hatena_bookmark_count => :environment do
      HatenaBookmarkCountCrawlJob.perform_later
    end
  end
end
