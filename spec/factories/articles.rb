FactoryGirl.define do
  factory :article do
    sequence(:url) { |i| "https://www.google#{i}.co.jp/" }
    sequence(:title) { |i| "Google#{i}" }
    sequence(:description) { |i| "検索エンジンだよ#{i}" }
    bookmark_date_time '2015/12/30 12:34:56'
  end
end
