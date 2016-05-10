require 'rails_helper'

RSpec.describe Reddit::RedditCrawlJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'キューにJobが正しく登録されること' do
      assert_enqueued_with(job: Reddit::RedditCrawlJob, args: ['dummy_url'], queue: 'rss') do
        # キューにジョブが登録されていないことを確認
        assert_no_enqueued_jobs
        # 実行
        Reddit::RedditCrawlJob.perform_later 'dummy_url'
        # キューにジョブが登録されたことを確認
        assert_enqueued_jobs 1
      end
    end

    it 'アプリケーションが例外をスローしないこと' do
      url = 'https://www.reddit.com/r/gifs/hot/.rss'
      VCR.use_cassette 'rss/www.reddit.com.gif' do
        expect {
          Reddit::RedditCrawlJob.perform_now url
        }.not_to raise_error
      end
    end
  end
end
