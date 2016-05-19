# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# 出力先logの指定
set :output, '/var/log/app/crontab.log'
# 実行環境の指定
set :environment, :production

every '*/25 * * * *' do
  rake 'batch:reddit:crawl'
end

# every '35 * * * *' do
#   rake 'batch:rss:crawl'
# end
#
# every '45 * * * *' do
#   rake 'batch:rss:hatena_bookmark_count_crawl'
#   rake 'batch:rss:facebook_count_crawl'
# end
