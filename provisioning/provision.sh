# MySQL
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO development_user@localhost IDENTIFIED BY 'development_password' WITH GRANT OPTION;"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO test_user@localhost IDENTIFIED BY 'test_password' WITH GRANT OPTION;"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO production_user@localhost IDENTIFIED BY 'production_password' WITH GRANT OPTION;"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u development_user -pdevelopment_password -e "CREATE DATABASE development_db CHARACTER SET utf8;"
mysql -u test_user -ptest_password -e "CREATE DATABASE test_db CHARACTER SET utf8;"
mysql -u production_user -pproduction_password -e "CREATE DATABASE production_db CHARACTER SET utf8;"

# app
sudo chmod 755 /opt
sudo chmod 777 /var/log/app/
sudo chmod 777 /var/run/app/

# rails
cd /vagrant
bundle install --path /home/vagrant/vendor/bundle
bundle exec rake db:migrate
bundle exec rspec

bundle exec sidekiq -C ./config/sidekiq.yml -d
bundle exec rake batch:reddit:crawl
bundle exec rails s -b 0.0.0.0 -d
