require 'rails_helper'

RSpec.describe Rss::RssCrawlTask, type: :task do
  include ActiveJob::TestHelper
  describe '#run' do
    it 'Jobが1件キューに登録されること' do
      # キューにジョブが登録されていないことを確認
      assert_no_enqueued_jobs
      # 実行
      Rss::RssCrawlTask.new.run
      # キューにジョブが登録されたことを確認
      assert_enqueued_jobs 1
      expect(enqueued_jobs.first[:job]).to eq Rss::RssCrawlJob
    end
  end

end
