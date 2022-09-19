require 'bundler'
require_relative './config/environment'

require_relative './app/api'

Api.compile!

run Api