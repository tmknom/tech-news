namespace :batch do
  desc 'バッチ処理の一覧表示'
  task :list => :environment do
    print `rake -T batch | grep -v Spring`
  end
end
