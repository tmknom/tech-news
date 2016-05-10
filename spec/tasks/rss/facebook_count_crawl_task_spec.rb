require 'rails_helper'

RSpec.describe Rss::FacebookCountCrawlTask, type: :task do
  include ActiveJob::TestHelper

  let!(:ratings) do
    create_list(:rating, 3)
  end

  describe '#run' do
    it 'FacebookCountCrawlJobが3件キューに登録されること' do
      # キューにジョブが登録されていないことを確認
      assert_no_enqueued_jobs
      # 実行
      Rss::FacebookCountCrawlTask.new.run
      # キューにジョブが登録されたことを確認
      assert_enqueued_jobs 3
      expect(enqueued_jobs.first[:job]).to eq FacebookCountCrawlJob
    end
  end

end
