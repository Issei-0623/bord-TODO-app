require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

if ['development', 'test'].include? ENV['RAILS_ENV']
  Dotenv::Railtie.load
end

module BordTodoApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # デフォルトロケールを日本語に設定（全環境で有効）
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [:en, :ja]

    # 本番環境でも日本時間を使用
    # 表示用のタイムゾーン（ビューや Time.current がこれになる）
    config.time_zone = 'Asia/Tokyo'  # または 'Tokyo'
    # DB への保存は UTC のままが安全（推奨）
    config.active_record.default_timezone = :utc

    if Rails.env.development? || Rails.env.test?
      Bundler.require(*Rails.groups)
      Dotenv::Railtie.load

      # Please, add to the `ignore` list any other `lib` subdirectories that do
      # not contain `.rb` files, or that should not be reloaded or eager loaded.
      # Common ones are `templates`, `generators`, or `middleware`, for example.
      config.autoload_lib(ignore: %w[assets tasks])

      # Configuration for the application, engines, and railties goes here.
      #
      # These settings can be overridden in specific environments using the files
      # in config/environments, which are processed later.
      #
      # config.time_zone = "Central Time (US & Canada)"
      # config.eager_load_paths << Rails.root.join("extras")
    end
  end
end
