require 'rails_helper'

RSpec.describe FacebookCountCrawlJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform_later' do
    it 'キューにJobが正しく登録されること' do
      assert_enqueued_with(job: FacebookCountCrawlJob, args: ['dummy_id'], queue: 'rating') do
        # キューにジョブが登録されていないことを確認
        assert_no_enqueued_jobs
        # 実行
        FacebookCountCrawlJob.perform_later 'dummy_id'
        # キューにジョブが登録されたことを確認
        assert_enqueued_jobs 1
      end
    end
  end
end
