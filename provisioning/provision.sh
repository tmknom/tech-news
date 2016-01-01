# 各種モジュールのインストール
yum install -y epel-release
yum update -y
yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
yum install -y git
yum install -y sqlite-devel
yum install -y nodejs

# rbenv + ruby-build
git clone https://github.com/rbenv/rbenv.git /opt/.rbenv
git clone https://github.com/rbenv/ruby-build.git /opt/.rbenv/plugins/ruby-build
echo 'export RBENV_ROOT="/opt/.rbenv"' >> /etc/profile.d/rbenv.sh
echo 'export PATH="/opt/.rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
source /etc/profile.d/rbenv.sh

# ruby
rbenv install 2.3.0
rbenv global 2.3.0
# gem & bundler & rails
gem update --system --no-document
gem update --no-document
gem install bundler --no-document

# MySQL
rpm -i http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
yum install -y mysql mysql-devel mysql-server mysql-utilities
mkdir /var/log/mysql
chown mysql:mysql /var/log/mysql
mkdir /var/lib/mysql/binlog
chown mysql:mysql /var/lib/mysql/binlog
chkconfig mysqld on
service mysqld start
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "FLUSH PRIVILEGES;"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO development_user@localhost IDENTIFIED BY 'development_password' WITH GRANT OPTION;"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO test_user@localhost IDENTIFIED BY 'test_password' WITH GRANT OPTION;"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO production_user@localhost IDENTIFIED BY 'production_password' WITH GRANT OPTION;"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u development_user -pdevelopment_password -e "CREATE DATABASE development_db CHARACTER SET utf8;"
mysql -u test_user -ptest_password -e "CREATE DATABASE test_db CHARACTER SET utf8;"
mysql -u production_user -pproduction_password -e "CREATE DATABASE production_db CHARACTER SET utf8;"

# redis
rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
rpm -iv http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
yum --enablerepo=remi install -y redis
chkconfig redis on
service redis start
