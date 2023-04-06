url = ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')
Redis.current = Redis.new(url: url)