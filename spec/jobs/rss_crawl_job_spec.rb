require 'rails_helper'

RSpec.describe RssCrawlJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform_later' do
    it 'キューにJobが正しく登録されること' do
      assert_enqueued_with(job: RssCrawlJob, args: ['sample1'], queue: 'default') do
        assert_no_enqueued_jobs
        RssCrawlJob.perform_later 'sample1'
        assert_enqueued_jobs 1
      end
    end
  end

end
