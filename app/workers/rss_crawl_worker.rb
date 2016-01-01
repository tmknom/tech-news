class RssCrawlWorker
  include Sidekiq::Worker

  # RssCrawlWorker.perform_async('hoge')
  def perform(name)
    p name
  end
end
