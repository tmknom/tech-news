require 'rails_helper'

RSpec.describe FacebookCountCrawlTask, type: :task do
  include ActiveJob::TestHelper

  let!(:ratings) do
    create_list(:rating, 3)
  end

  describe '#run' do
    it 'FacebookCountCrawlJobが3件キューに登録されること' do
      assert_no_enqueued_jobs
      FacebookCountCrawlTask.new.run
      assert_enqueued_jobs 3
      expect(enqueued_jobs.first[:job]).to eq FacebookCountCrawlJob
    end
  end

end
