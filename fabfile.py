# -*- encoding:utf-8 -*-

from fabric.api import *

APPLICATION_NAME = 'tech-news'
REPOSITORY = 'tmknom/tech-news'

ADMINISTRATION = 'Administration'
PRODUCTION = 'Production'


@task
def deploy_production(branch='master'):
    '''Production 環境へデプロイ'''
    deploy(branch, PRODUCTION)


@task
def deploy_administration(branch='master'):
    '''Administration 環境へデプロイ'''
    deploy(branch, ADMINISTRATION)


def deploy(branch, environment):
    recent_commit_id = get_recent_commit_id(branch)
    create_deployment(recent_commit_id, environment)


def create_deployment(commit_id, environment):
    region = get_default_region()
    deployment_group_name = environment + '-' + APPLICATION_NAME
    execute_create_deployment(commit_id, deployment_group_name, region, APPLICATION_NAME, REPOSITORY)


def execute_create_deployment(commit_id, deployment_group_name, region, application_name, repository):
    command = "aws deploy create-deployment " \
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
    '''RDS にデータベースとユーザを作成'''
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
    '''DB 接続するための環境変数を定義'''
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


@task
def cleanup_code_deploy():
    '''CodeDeploy のゴミを削除する'''
    sudo('rm -Rf /opt/codedeploy-agent/deployment-root/*')
