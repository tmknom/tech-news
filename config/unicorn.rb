# unicorn の設定
#
# 参考文献
#  - nginx 実践入門
#  - https://github.com/defunkt/unicorn/blob/master/examples/unicorn.conf.rb
#  - http://qiita.com/syou007/items/555062cc96dd0b08a610
#  - https://github.com/herokaijp/devcenter/wiki/Rails-unicorn

LOG_DIR = '/var/log/app'
PID_DIR = '/var/run/app'

rails_root = File.expand_path('../../', __FILE__)
ENV['BUNDLE_GEMFILE'] = rails_root + '/Gemfile'

# ワーカープロセス数
# Vagrant では WEB_CONCURRENCY を 2 に設定している
worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)

# タイムアウト時間（秒）
timeout 15

# PID
pid "#{PID_DIR}/unicorn.pid"

# リッスンするソケットの指定
# ここではUNIXドメインソケットを指定している
listen "#{PID_DIR}/unicorn.sock"

# 標準出力、標準エラー出力のロギング
stdout_path "#{LOG_DIR}/unicorn.stdout.log"
stderr_path "#{LOG_DIR}/unicorn.stderr.log"

# ワーカーをforkする前に、アプリケーションをロードする設定
# Unicornの再起動時にダウンタイムなしで再起動が行うために必要なのでtrueにしておく
preload_app true

# 冪等性のない処理をフックメソッド内で実行するときに、複数回実行されないよう設定するフラグ
# local variable to guard against running a hook multiple times
run_once = true

before_fork do |server, worker|
  # これを設定しないと、ワーカーをforkするとき、socketごとforkされて、
  # 複数プロセスがsocketを共用する状態が生まれてしまう
  # そこで、明示的にコネクションを切断し、fork後に明示的に繋ぎ直す(after_forkでやる)
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

  # 複数回実行されては困る処理があり場合はココに書く
  # 現時点では、特にないため、フラグをfalseにするだけ
  # Occasionally, it may be necessary to run non-idempotent code in the
  # master before forking.  Keep in mind the above disconnect! example
  # is idempotent and does not need a guard.
  if run_once
    # do_something_once_here ...
    run_once = false # prevent from firing again
  end

  # The following is only recommended for memory/DB-constrained
  # installations.  It is not needed if your system can house
  # twice as many worker_processes as you have configured.
  #
  # This allows a new master process to incrementally
  # phase out the old master process with SIGTTOU to avoid a
  # thundering herd (especially in the "preload_app false" case)
  # when doing a transparent upgrade.  The last worker spawned
  # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      # STDERR.puts "#{e.class} #{e.message}"
    end
  end

  # 順次workerをkillするために、sleepをいれてforkされる速度を落としておく
  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  sleep 1
end


after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # before_forkでコネクションを一旦切っているので、再接続しに行ってるっぽい
  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end
