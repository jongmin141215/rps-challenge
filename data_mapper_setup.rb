require 'data_mapper'

if ENV['RACK_ENV'] = 'production'
  DataMapper.setup(:default, ENV['DATABASE_URL'])
else
  env = ENV['RACK_ENV'] || 'development'
  DataMapper.setup(:default, "postgres://localhost/rps_#{env}")
end

require './lib/game'
require './lib/user'
require './lib/rps'

DataMapper.finalize

DataMapper.auto_upgrade!
