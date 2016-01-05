require 'rails_helper'

RSpec.describe FacebookCountCrawlJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform_later' do
    it 'キューにJobが正しく登録されること' do
      assert_enqueued_with(job: FacebookCountCrawlJob, args: ['dummy_url'], queue: 'default') do
        # キューにジョブが登録されていないことを確認
        assert_no_enqueued_jobs
        # 実行
        FacebookCountCrawlJob.perform_later 'dummy_url'
        # キューにジョブが登録されたことを確認
        assert_enqueued_jobs 1
      end
    end
  end
end
