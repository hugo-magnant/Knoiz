Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"] }
  config.logger = Logger.new(File.join(Rails.root, 'log', 'sidekiq.log'), 5, 10.megabytes)
  config.logger.level = Logger::INFO  # Set log level as appropriate
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"] }
end
