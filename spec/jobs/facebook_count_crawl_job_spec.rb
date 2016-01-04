require 'rails_helper'

RSpec.describe FacebookCountCrawlJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform_later' do
    it 'キューにJobが正しく登録されること' do
      assert_enqueued_with(job: FacebookCountCrawlJob, args: [], queue: 'default') do
        assert_no_enqueued_jobs
        FacebookCountCrawlJob.perform_later
        assert_enqueued_jobs 1
      end
    end
  end
end