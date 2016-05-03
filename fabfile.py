# -*- encoding:utf-8 -*-

from fabric.api import *
from datetime import datetime

REPOSITORY = 'tmknom/tech-news'
WORK_DIR = datetime.now().strftime("%Y%m%d_%H%M%S")
RELEASES_DIR = 'releases'
CURRENT_DIR = 'current'


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
