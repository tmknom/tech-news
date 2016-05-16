# -*- encoding:utf-8 -*-

from fabric.api import *

from database import database
from operation import operation


@task
def deploy_production(branch='master'):
    '''Production 環境へデプロイ :<branch>'''
    operation.deploy_production(branch)


@task
def deploy_testing(branch=''):
    '''Testing 環境へデプロイ :<branch>'''
    operation.deploy_testing(branch)


@task
def cleanup_code_deploy():
    '''CodeDeploy のゴミを削除する [-H <ip_address>]'''
    init_fabric()
    operation.cleanup_code_deploy()


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


def init_fabric():
    env.user = get_local_env('SSH_USER_NAME')
    env.port = get_local_env('SSH_PORT')
    env.key_filename = [get_local_env('SSH_PRIVATE_KEY_FULL_PATH')]


def get_local_env(env_name):
    return local('echo $%s' % (env_name), capture=True)
