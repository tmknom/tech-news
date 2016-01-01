class RssCrawlJob < ActiveJob::Base
  queue_as :default

  # RssCrawlJob.perform_later 'sample'
  def perform(name)
    p name
  end
end
