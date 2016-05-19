require 'rails_helper'

RSpec.describe Reddit::RedditCrawlJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'キューにJobが正しく登録されること' do
      assert_enqueued_with(job: Reddit::RedditCrawlJob, args: [Reddit::RedditCategory::GIFS], queue: 'rss') do
        # キューにジョブが登録されていないことを確認
        assert_no_enqueued_jobs
        # 実行
        Reddit::RedditCrawlJob.perform_later Reddit::RedditCategory::GIFS
        # キューにジョブが登録されたことを確認
        assert_enqueued_jobs 1
      end
    end

    it 'アプリケーションが例外をスローしないこと' do
      VCR.use_cassette 'reddit/www.reddit.com' do
        expect {
          Reddit::RedditCrawlJob.perform_now Reddit::RedditCategory::GIFS
        }.not_to raise_error
      end
    end
  end
end
