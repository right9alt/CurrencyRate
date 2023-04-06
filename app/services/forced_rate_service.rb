class ForcedRateService

  def self.call(forced_rate)
    new(forced_rate).call
  end

  def initialize(forced_rate)
    @forced_rate = forced_rate
  end

  def call
    destroy_job if forced_rate_exists?
    create_job
  end

  private
  def destroy_job
    current_forced_rate = ForcedRate.where(archive: false).where.not(id: @forced_rate.id)&.first
    current_forced_rate.update_column(:archive, true)
    Sidekiq::Cron::Job.destroy "forced_rate_#{current_forced_rate.id}"
  end

  def forced_rate_exists?
    ForcedRate.where(archive: false).where.not(id: @forced_rate.id).exists?(archive: false)
  end

  def create_job
    Sidekiq::Cron::Job.destroy "forced_rate_#{ForcedRate.second_to_last&.id}"
    ActionCable.server.broadcast('rate_channel', { rate: @forced_rate.to_json, partial: 'rate' })
    Sidekiq::Cron::Job.create(name: "forced_rate_#{@forced_rate.id}", cron: @forced_rate.until_time.strftime('%M %H %d %m *'), class: "ForcedRateWorker", args: [@forced_rate.id])
  end
end