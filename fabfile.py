# -*- encoding:utf-8 -*-

from fabric.api import *
from datetime import datetime

REPOSITORY = 'tmknom/tech-news'
WORK_DIR = datetime.now().strftime("%Y%m%d_%H%M%S")
RELEASES_DIR = 'releases'
CURRENT_DIR = 'current'


@task
def deploy():
    execute_deploy()


def execute_deploy():
    stop()
    initialize_dir()
    clone()
    symlink()
    bundle_install()
    db_migrate()
    env()
    start()
    cron()


def initialize_dir():
    env.release_dir = RELEASES_DIR + '/' + WORK_DIR
    sudo('mkdir -p /var/log/app')
    sudo('chmod 777 /var/log/app')
    run('mkdir -p %s' % (RELEASES_DIR))


def env():
    secret_key_base = run('printenv SECRET_KEY_BASE', warn_only=True)
    if not secret_key_base:
        with cd(CURRENT_DIR):
            secret_key_base = run('RAILS_ENV=production bundle exec rake secret')
            run('echo "export SECRET_KEY_BASE=%s" >> ~/.bash_profile' % (secret_key_base))
            run('source ~/.bash_profile')


def clone():
    repository_url = 'https://github.com/' + REPOSITORY + '.git'
    with cd(RELEASES_DIR):
        run('git clone %s %s' % (repository_url, WORK_DIR))


def symlink():
    run('ln -snf %s %s' % (env.release_dir, CURRENT_DIR))


def bundle_install():
    with cd(CURRENT_DIR):
        run('git checkout master')
        run('bundle install --path vendor/bundle --without development')


def db_migrate():
    with cd(CURRENT_DIR):
        run('RAILS_ENV=production bundle exec rake db:migrate')


def start():
    with cd(CURRENT_DIR):
        run('RAILS_ENV=production bundle exec rails s -b 0.0.0.0 -d', pty=False)
        run(
            'RAILS_ENV=production bundle exec sidekiq -q default -q rss -q rating -L /var/log/app/sidekiq.log -P tmp/pids/sidekiq.pid -d',
            pty=False)


def stop():
    with cd(CURRENT_DIR):
        run('RAILS_ENV=production bundle exec sidekiqctl stop tmp/pids/sidekiq.pid', warn_only=True)
        run('cat tmp/pids/server.pid | xargs kill -9', warn_only=True)


def cron():
    with cd(CURRENT_DIR):
        run('bundle exec whenever --update-crontab')


@task
def init_db():
    create_user()
    create_db()


def create_user():
    db_name = get_local_env('DATABASE_DB')
    user_name = get_local_env('DATABASE_USER_NAME')
    password = get_local_env('DATABASE_USER_PASSWORD')
    sql = ' GRANT ALL ON %s.* TO %s ' % (db_name, user_name) \
          + ' IDENTIFIED BY \'%s\'; ' % (password) \
          + ' FLUSH PRIVILEGES; '

    master_user_name = get_local_env('DATABASE_MASTER_USER_NAME')
    master_user_password = get_local_env('DATABASE_MASTER_USER_PASSWORD')
    execute_sql(master_user_name, master_user_password, sql)


def create_db():
    db_name = get_local_env('DATABASE_DB')
    sql = 'CREATE DATABASE IF NOT EXISTS %s DEFAULT CHARACTER SET utf8;' % (db_name)

    user_name = get_local_env('DATABASE_USER_NAME')
    password = get_local_env('DATABASE_USER_PASSWORD')
    execute_sql(user_name, password, sql)


def execute_sql(user_name, password, sql):
    host = get_local_env('DATABASE_HOST')
    port = get_local_env('DATABASE_PORT')
    run('mysql -h %s -P %s -u %s -p%s -e "%s"' % (host, port, user_name, password, sql))


@task
def init_env():
    set_remote_env('DATABASE_HOST')
    set_remote_env('DATABASE_PORT')
    set_remote_env('DATABASE_DB')
    set_remote_env('DATABASE_USER_NAME')
    set_remote_env('DATABASE_USER_PASSWORD')


def set_remote_env(key):
    value = get_local_env(key)
    sudo('echo "export %s=\'%s\'" >> %s' % (key, value, BASH_PROFILE), user='ec2-user')


def get_local_env(key):
    return local('echo $%s' % (key), capture=True)


BASH_PROFILE = '/home/ec2-user/.bash_profile'
