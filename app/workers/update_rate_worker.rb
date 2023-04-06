class UpdateRateWorker
  include Sidekiq::Worker
  #Хоть курс ежедневный, решил для чистоты эксперимента каждые 15 секунд его обновлять
  def perform
    puts Time.now
    unless ForcedRate.last&.archive == false
      CreateRateService.call
      ActionCable.server.broadcast('rate_channel', { rate: Rate.last.to_json, partial: 'rate' })
    end
  end
end