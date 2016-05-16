# -*- encoding:utf-8 -*-

from fabric.api import *
from fabric.contrib.console import *

PRODUCTION = 'Production'
ADMINISTRATION = 'Administration'


def initialize_production():
    initialize(PRODUCTION)


def initialize_administration():
    initialize(ADMINISTRATION)


def initialize(environment):
    if not confirm("RDS にデータベースとユーザを作成します。本当に実行しますか？"):
        abort('実行を中止しました。')
    create_user(environment)
    create_db(environment)


def create_user(environment):
    db_name = get_local_env('DATABASE_DB')
    user_name = get_local_env('DATABASE_USER_NAME')
    password = get_local_env('DATABASE_USER_PASSWORD')
    sql = ' GRANT ALL ON %s.* TO %s ' % (db_name, user_name) \
          + ' IDENTIFIED BY \'%s\'; ' % (password) \
          + ' FLUSH PRIVILEGES; '

    master_user_name = get_local_env('DATABASE_MASTER_USER_NAME')
    master_user_password = get_master_user_password(environment)
    execute_sql(environment, master_user_name, master_user_password, sql)


def create_db(environment):
    db_name = get_local_env('DATABASE_DB')
    sql = 'CREATE DATABASE IF NOT EXISTS %s DEFAULT CHARACTER SET utf8;' % (db_name)

    user_name = get_local_env('DATABASE_USER_NAME')
    password = get_local_env('DATABASE_USER_PASSWORD')
    execute_sql(environment, user_name, password, sql)


def execute_sql(environment, user_name, password, sql):
    host = get_host(environment)
    port = get_local_env('DATABASE_PORT')
    run('mysql -h %s -P %s -u %s -p%s -e "%s"' % (host, port, user_name, password, sql))


def get_master_user_password(environment):
    if environment == PRODUCTION:
        return get_local_env('DATABASE_MASTER_USER_PASSWORD_PRODUCTION')
    else:
        return get_local_env('DATABASE_MASTER_USER_PASSWORD_ADMINISTRATION')


def get_host(environment):
    if environment == PRODUCTION:
        return get_local_env('DATABASE_HOST_PRODUCTION')
    else:
        return get_local_env('DATABASE_HOST_ADMINISTRATION')


def get_local_env(env_name):
    return local('echo $%s' % (env_name), capture=True)
