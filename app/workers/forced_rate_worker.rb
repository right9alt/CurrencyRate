class ForcedRateWorker
  include Sidekiq::Worker

  def perform(forced_rate_id)
    forced_rate = ForcedRate.find(forced_rate_id)
    # Архивируем текущий форсированный курс
    forced_rate.update_column(:archive, true)
    # Выполняем обновление курса
    UpdateRateWorker.perform_async
  end
end