require 'rails_helper'

RSpec.describe Rss::HatenaBookmarkCountCrawlTask, type: :task do
  include ActiveJob::TestHelper

  let!(:ratings) do
    create_list(:rating, 3)
  end

  describe '#run' do
    it 'Jobが3件キューに登録されること' do
      # キューにジョブが登録されていないことを確認
      assert_no_enqueued_jobs
      # 実行
      Rss::HatenaBookmarkCountCrawlTask.new.run
      # キューにジョブが登録されたことを確認
      assert_enqueued_jobs 3
      expect(enqueued_jobs.first[:job]).to eq HatenaBookmarkCountCrawlJob
    end
  end

end
