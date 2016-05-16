# -*- encoding:utf-8 -*-

from fabric.api import *
from fabric.contrib.console import *

from database import database

APPLICATION_NAME = 'tech-news'
REPOSITORY = 'tmknom/tech-news'

TESTING = 'Testing'
PRODUCTION = 'Production'


@task
def deploy_production(branch='master'):
    '''Production 環境へデプロイ :<branch>'''
    if not confirm("%s ブランチを Production 環境へデプロイします。本当に実行しますか？" % (branch)):
        abort('実行を中止しました。')
    deploy(branch, PRODUCTION)


@task
def deploy_testing(branch=''):
    '''Testing 環境へデプロイ :<branch>'''
    deploy(get_branch(branch), TESTING)


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


def get_branch(branch):
    if not branch:
        return branch
    return get_current_branch()


def get_current_branch():
    command = "git rev-parse --abbrev-ref HEAD"
    result = local(command, capture=True)
    return result


@task
def database_initialize_production():
    '''本番用 RDS にデータベースとユーザを作成 [-H <ip_address>]'''
    init_fabric()
    database.initialize_production()


@task
def database_initialize_administration():
    '''管理用 RDS にデータベースとユーザを作成 [-H <ip_address>]'''
    init_fabric()
    database.initialize_administration()


@task
def cleanup_code_deploy():
    '''CodeDeploy のゴミを削除する [-H <ip_address>]'''
    init_fabric()
    sudo('rm -Rf /opt/codedeploy-agent/deployment-root/*')


def init_fabric():
    env.user = get_local_env('SSH_USER_NAME')
    env.port = get_local_env('SSH_PORT')
    env.key_filename = [get_local_env('SSH_PRIVATE_KEY_FULL_PATH')]


def get_local_env(env_name):
    return local('echo $%s' % (env_name), capture=True)
