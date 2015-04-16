require 'uri'
require 'ohm'

redis_url = ENV['REDISCLOUD_URL'] ||
            ENV['OPENREDIS_URL']  ||
            ENV['REDISGREEN_URL'] ||
            ENV['REDISTOGO_URL']  ||
            'redis://127.0.0.1:6379'

Ohm.redis = Redic.new(URI.parse(redis_url).to_s)
