require 'bundler/setup'

Bundler.require(:default, ENV.fetch('APP_ENV', 'development'))

Dotenv.load('.env', ".env.#{ENV.fetch('APP_ENV', 'development')}")

require 'dry-initializer'
require 'i18n'
require 'grape-route-helpers'
require 'grape-route-helpers/tasks'

require_relative 'initializers/i18n'
require_relative 'initializers/sequel'

DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
DB.extension(:pagination)

Dir['app/**/*.rb'].each do |m|
  require_relative "../#{m}"
end