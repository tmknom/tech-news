namespace :command do
  desc '便利コマンドの一覧表示'
  task :list do
    print `bin/rake -T command | grep -v Spring`
  end
end
