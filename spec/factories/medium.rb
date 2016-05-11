FactoryGirl.define do
  factory :medium do
    sequence(:url) { |i| "https://www.google#{i}.co.jp/example.gif" }
    sequence(:source_url) { |i| "https://www.google#{i}.co.jp/" }
    category Medium::CATEGORY_IMAGE
  end
end
