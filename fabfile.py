# -*- encoding:utf-8 -*-

from fabric.api import *
from fabric.contrib.console import *

APPLICATION_NAME = 'tech-news'
REPOSITORY = 'tmknom/tech-news'

TESTING = 'Testing'
PRODUCTION = 'Production'


@task
def deploy_production(branch='master'):
    '''Production 環境へデプロイ :<branch>'''
    if not confirm("Production 環境へデプロイします。本当に実行しますか？"):
        abort('実行を中止しました。')
    deploy(branch, PRODUCTION)


@task
def deploy_testing(branch='master'):
    '''Testing 環境へデプロイ :<branch>'''
    deploy(branch, TESTING)


def deploy(branch, environment):
    recent_commit_id = get_recent_commit_id(branch)
    create_deployment(recent_commit_id, environment)


def create_deployment(commit_id, environment):
    region = get_default_region()
    deployment_group_name = environment + '-' + APPLICATION_NAME
    execute_create_deployment(commit_id, deployment_group_name, region, APPLICATION_NAME, REPOSITORY)


def execute_create_deployment(commit_id, deployment_group_name, region, application_name, repository):
    command = "aws deploy create-deployment " \
              + " --ignore-application-stop-failures " \
              + " --region %s " % (region) \
              + " --application-name %s " % (application_name.lower()) \
              + " --deployment-group-name %s " % (deployment_group_name.lower()) \
              + " --github-location commitId=%s,repository=%s " % (commit_id, repository)
    result = local(command, capture=True)
    return result


def get_default_region():
    command = 'aws configure get region'
    result = local(command, capture=True)
    return result


def get_recent_commit_id(branch):
    command = 'git log -n 1 --format=%H ' + branch
    result = local(command, capture=True)
    return result


@task
def init_db():
    '''RDS にデータベースとユーザを作成 [-H <ip_address>]'''
    if not confirm("RDS にデータベースとユーザを作成します。本当に実行しますか？"):
        abort('実行を中止しました。')
    init_fabric()
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
