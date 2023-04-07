require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ForcedRateWorker, type: :worker do
  # Используем Sidekiq::Testing.fake! для имитации фоновых задач
  
  before { Sidekiq::Testing.fake! }

  describe '#perform' do
    include FactoryBot::Syntax::Methods
    let!(:forced_rate) { create(:forced_rate, archive: false) }
    let(:forced_rate_id) { forced_rate.id }

    it 'archives the current forced rate and enqueues UpdateRateWorker' do
      expect(UpdateRateWorker).to receive(:perform_async) # Проверяем, что UpdateRateWorker выполняется асинхронно
      expect {
        subject.perform(forced_rate_id)
      }.to change { forced_rate.reload.archive }.from(false).to(true) # Проверяем, что archive становится true
    end
  end
end
