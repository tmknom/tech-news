require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TechNews
  class Application < Rails::Application
    # 手動追加部分

    # オートロード設定
    config.autoload_paths += %W(#{config.root}/app/infrastructures/repositories)
    config.autoload_paths += %W(#{config.root}/app/infrastructures/gateways)

    # Active Jobでsidekiqを使うための設定
    # https://github.com/mperham/sidekiq/wiki/Active-Job#active-job-setup
    config.active_job.queue_adapter = :sidekiq

    # タイムゾーンの設定
    # http://twodollarz.hatenablog.jp/entry/20120703
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc


    # 自動作成部分

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
