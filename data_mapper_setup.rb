require 'data_mapper'

env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, "postgres://localhost/rps_#{env}")

require './lib/game'
require './lib/user'
require './lib/rps'

DataMapper.finalize

DataMapper.auto_upgrade!
