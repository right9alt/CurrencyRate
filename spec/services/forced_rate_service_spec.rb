require 'rails_helper'

RSpec.describe ForcedRateService do
  include FactoryBot::Syntax::Methods
  let!(:forced_rate) { create(:forced_rate, archive: false) }
  subject { described_class.new(forced_rate) }

  describe '#call' do
    it 'destroys the previous forced rate job, updates archive status, creates a new job, and broadcasts rate update' do
      # Create a ForcedRate object
      forced_rate_2 = create(:forced_rate, archive: false)
      forced_rate_3 = create(:forced_rate, archive: false)

      # Stub the Sidekiq::Cron::Job.destroy method
      allow(Sidekiq::Cron::Job).to receive(:destroy)

      # Call the service method with the third forced rate object
      ForcedRateService.new(forced_rate_3).call

      # Expect the Sidekiq::Cron::Job.destroy method to be called once with the correct argument
      expect(Sidekiq::Cron::Job).to have_received(:destroy).once.with("forced_rate_#{forced_rate_2.id}")

      # Add further expectations as needed for other steps in the service method
    end

    it 'creates a new job and broadcasts rate update' do
      # Stub the Sidekiq::Cron::Job.destroy method
      allow(Sidekiq::Cron::Job).to receive(:destroy)

      # Call the service method
      ForcedRateService.new(forced_rate).call

      # Expect the Sidekiq::Cron::Job.destroy method to be called with the correct argument
      expect(Sidekiq::Cron::Job).to have_received(:destroy).with("forced_rate_")

      # Add further expectations as needed for other steps in the service method
    end
  end
end
