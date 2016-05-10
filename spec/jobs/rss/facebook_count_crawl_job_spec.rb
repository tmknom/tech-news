require 'rails_helper'

RSpec.describe Rss::FacebookCountCrawlJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform_later' do
    it 'キューにJobが正しく登録されること' do
      assert_enqueued_with(job: Rss::FacebookCountCrawlJob, args: ['dummy_id'], queue: 'rating') do
        # キューにジョブが登録されていないことを確認
        assert_no_enqueued_jobs
        # 実行
        Rss::FacebookCountCrawlJob.perform_later 'dummy_id'
        # キューにジョブが登録されたことを確認
        assert_enqueued_jobs 1
      end
    end
  end
end
