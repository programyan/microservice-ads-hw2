require 'bundler/setup'
require 'rake'
Bundler.setup

Bundler.require(:default, ENV.fetch('APP_ENV', 'development'))

Dotenv.load('.env', ".env.#{ENV.fetch('APP_ENV', 'development')}")

require 'grape-route-helpers'
require 'grape-route-helpers/tasks'

task :environment do
  require File.expand_path('app/api', File.dirname(__FILE__))
end

namespace :db do
  require 'sequel/core'
  Sequel.extension :migration

  desc 'Create Database'
  task :create do
    db_url = ENV.fetch('DATABASE_URL')
    db_name = db_url.split('/').last
    Sequel.connect(ENV.fetch('DATABASE_URL').gsub(db_name, '')) do |db|
      db.execute "DROP DATABASE IF EXISTS #{db_name}"
      db.execute "CREATE DATABASE #{db_name}"
    end
  end

  desc 'Run migrations'
  task :migrate, [:version] do |t, args|
    version = args[:version].to_i if args[:version]
    Sequel.connect(ENV.fetch("DATABASE_URL")) do |db|
      Sequel::Migrator.run(db, "db/migrations", target: version)
    end
  end

  desc 'Generate migration'
  task :create_migration, [:name] do |_task, args|
    File.open("db/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{args[:name]}.rb", 'w+') do |file|
      file.write("Sequel.migration do\n  change do\n\n  end\nend\n")
    end
  end

  desc 'Seeds'
  task :seed do
    Sequel.connect(ENV.fetch("DATABASE_URL")) do |db|
      require_relative 'config/initializers/sequel'
      require_relative 'app/models/ad'

      (1..10).each do |index|
        Ad.create(
          user_id: rand(3),
          title: "Title #{index}",
          description: "Lorem ipusm dolor sit amet #{index}",
          city: ['Хабаровск', 'Санкт-Петербург'].sample
        )
      end
    end
  end
end

desc 'Print routes'
task :routes do
  require_relative 'app/api'
  Api.routes.each do |route|
    method = route.request_method.ljust(10)
    path = route.origin
    puts "     #{method} #{path}"
  end
end

