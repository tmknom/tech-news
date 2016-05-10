require 'rails_helper'

RSpec.describe Rss::RssCrawlJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    it 'キューにJobが正しく登録されること' do
      assert_enqueued_with(job: Rss::RssCrawlJob, args: ['dummy_url'], queue: 'rss') do
        # キューにジョブが登録されていないことを確認
        assert_no_enqueued_jobs
        # 実行
        Rss::RssCrawlJob.perform_later 'dummy_url'
        # キューにジョブが登録されたことを確認
        assert_enqueued_jobs 1
      end
    end

    it 'アプリケーションが例外をスローしないこと' do
      url = 'http://b.hatena.ne.jp/entrylist/it?sort=hot&threshold=30&mode=rss'
      VCR.use_cassette 'rss/b.hatena.ne.jp' do
        expect {
          Rss::RssCrawlJob.perform_now url
        }.not_to raise_error
      end
    end
  end

end
