# unicorn の設定
# nginx 実践入門をベースにしている

# http://qiita.com/syou007/items/555062cc96dd0b08a610
rails_root = File.expand_path('../../', __FILE__)
ENV['BUNDLE_GEMFILE'] = rails_root + "/Gemfile"


# この二行だけ下記の参考サイトより抜粋
# https://github.com/herokaijp/devcenter/wiki/Rails-unicorn
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15

# PID
pid "/home/ec2-user/tmp/pids/unicorn.pid"

# リッスンするソケットの指定
# ここではUNIXドメインソケットを指定している
listen "/home/ec2-user/tmp/pids/unicorn.sock"

# 標準出力、標準エラー出力のロギング
stdout_path "/var/log/app/unicorn.stdout.log"
stderr_path "/var/log/app/unicorn.stderr.log"

