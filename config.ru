require 'bundler/setup'

require 'rack/contrib'
require 'rack-cache'
require 'dalli'
require 'memcachier'
require './api/lib/rack/static_cache'

require './api/app'

# Gzip responses
use Rack::Deflater


if ENV['RACK_ENV'] == 'production'
  # Set Cache-Control and ETag headers
  use Rack::StaticCache, urls: ['/js', '/css', '/fonts', '/favicon.ico'], root: 'public', duration: 90

  if memcachier_servers = ENV['MEMCACHIER_SERVERS']
    cache = Dalli::Client.new memcachier_servers.split(','), {
      username: ENV['MEMCACHIER_USERNAME'],
      password: ENV['MEMCACHIER_PASSWORD']
    }
    use Rack::Cache, verbose: true, metastore: cache, entitystore: cache
  end

  # Run the application
  run RoughdraftApp

else
  use Rack::Cache,
    verbose: true,
    metastore:   'memcached://localhost:11211',
    entitystore: 'memcached://localhost:11211'

  # Run the application
  run RoughdraftApp

end

