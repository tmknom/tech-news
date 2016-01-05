namespace :command do
  namespace :sidekiq do
    require 'sidekiq/api'

    desc 'Sidekiqのジョブを全てクリア'
    task :clear_all do
      p 'clear Queue : ' + Sidekiq::Queue.new.clear.to_s
      p 'clear ScheduledSet : ' + Sidekiq::ScheduledSet.new.clear.to_s
      p 'clear RetrySet : ' + Sidekiq::RetrySet.new.clear.to_s
      p 'clear DeadSet : ' + Sidekiq::DeadSet.new.clear.to_s
    end
  end
end
