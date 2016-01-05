namespace :command do
  namespace :sidekiq do
    require 'sidekiq/api'
    require 'awesome_print'

    # SidekiqのAPIドキュメント
    # https://github.com/mperham/sidekiq/wiki/API

    desc 'Sidekiqのジョブ一覧を表示'
    task :show_all do
      queues, scheduled_set, retry_set, dead_set = [], [], [], []

      Sidekiq::Queue.new.each { |job| queues << create_pretty_job(job) }
      Sidekiq::ScheduledSet.new.each { |job| scheduled_set << create_pretty_job(job) }
      Sidekiq::RetrySet.new.each { |job| retry_set << create_pretty_job(job) }
      Sidekiq::DeadSet.new.each { |job| dead_set << create_pretty_job(job) }

      show(queues.sort, scheduled_set.sort, retry_set.sort, dead_set.sort)
    end

    desc 'Sidekiqのジョブ一覧を詳細表示'
    task :show_verbose_all do
      queues, scheduled_set, retry_set, dead_set = [], [], [], []

      Sidekiq::Queue.new.each { |job| queues << create_verbose_job(job) }
      Sidekiq::ScheduledSet.new.each { |job| scheduled_set << create_verbose_job(job) }
      Sidekiq::RetrySet.new.each { |job| retry_set << create_verbose_job(job) }
      Sidekiq::DeadSet.new.each { |job| dead_set << create_verbose_job(job) }

      show(queues, scheduled_set, retry_set, dead_set)
    end

    desc 'Sidekiqのステータスを表示'
    task :show_status do
      ap JSON.parse(Sidekiq::Stats.new.to_json)['stats']
    end

    desc 'Sidekiqのジョブを全てクリア'
    task :clear_all do
      queues = Sidekiq::Queue.new.clear
      scheduled_set = Sidekiq::ScheduledSet.new.clear
      retry_set = Sidekiq::RetrySet.new.clear
      dead_set = Sidekiq::DeadSet.new.clear

      cleared ={}
      cleared.store(:queue, queues[0]) unless queues[0] == 0
      cleared.store(:scheduled, scheduled_set) unless scheduled_set == 0
      cleared.store(:retry, retry_set) unless retry_set == 0
      cleared.store(:dead, dead_set) unless dead_set == 0

      result = {cleared: cleared}
      ap result unless cleared.empty?
      ap 'job is empty!' if cleared.empty?
    end


    private

    def show(queues, scheduled_set, retry_set, dead_set)
      jobs = create_jobs(queues, scheduled_set, retry_set, dead_set)
      ap jobs unless jobs.empty?
      ap 'job is empty!' if jobs.empty?
    end

    def create_jobs(queues, scheduled_set, retry_set, dead_set)
      result ={}
      result.store(:queue, queues) unless queues.empty?
      result.store(:scheduled, scheduled_set) unless scheduled_set.empty?
      result.store(:retry, retry_set) unless retry_set.empty?
      result.store(:dead, dead_set) unless dead_set.empty?
      result
    end

    def create_pretty_job(job)
      job_class = job.args[0]['job_class']
      arguments = job.args[0]['arguments'].join(',')
      queue = job.queue
      created_at = format_time(job.created_at)
      "#{created_at} #{queue} #{job_class}(#{arguments})"
    end

    def create_verbose_job(job)
      {
          class: job.args[0]['job_class'],
          arguments: job.args[0]['arguments'].size == 1 ? job.args[0]['arguments'][0] : job.args[0]['arguments'],
          queue: job.queue,
          created_at: format_time(job.created_at),
          enqueued_at: format_time(job.enqueued_at),
          jid: job.jid,
          job_id: job.args[0]['job_id']
      }
    end

    def format_time(time)
      time.in_time_zone('Tokyo').strftime('%Y/%m/%d %H:%M:%S')
    end
  end
end
