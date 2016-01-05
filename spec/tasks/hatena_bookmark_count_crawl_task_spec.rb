require 'rails_helper'

RSpec.describe HatenaBookmarkCountCrawlTask, type: :task do
  include ActiveJob::TestHelper

  let!(:ratings) do
    create_list(:rating, 3)
  end

  describe '#run' do
    it 'Jobが3件キューに登録されること' do
      assert_no_enqueued_jobs
      HatenaBookmarkCountCrawlTask.new.run
      assert_enqueued_jobs 3
    end
  end

end
