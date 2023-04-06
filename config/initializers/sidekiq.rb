Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
  schedule_file = 'config/sidekiq.yml'

  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)[:schedule]
  end
    config.on(:startup) do
      Sidekiq::Cron::Job.all.each do |jb|
        if jb.klass == "ForcedRateWorker" 
          ForcedRateWorker.perform_async(jb.args.first) if DateTime.strptime(jb.cron, '%M %H %d %m *').strftime('%Y-%m-%d %H:%M:%S Moscow').to_time < DateTime.now
        end
      end
    end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end

