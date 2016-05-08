FactoryGirl.define do
  factory :reddit_article do
    sequence(:url) { |i| "https://www.google#{i}.co.jp/" }
    sequence(:title) { |i| "Google#{i}" }
    sequence(:image_url) { |i| "https://www.google#{i}.co.jp/example.gif" }
    sequence(:description) { |i| "検索エンジンだよ#{i}" }
  end
end
