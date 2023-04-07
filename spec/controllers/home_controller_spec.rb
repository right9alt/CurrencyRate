require 'rails_helper'
require 'factory_bot_rails' 

RSpec.describe HomeController, type: :controller do
  include FactoryBot::Syntax::Methods
  let!(:forced_rate) { create(:forced_rate, archive: false) } # Создаем тестовые данные
  let!(:rate) { create(:rate) } # Создаем тестовые данные
  describe "GET #index" do
    let!(:forced_rate) { create(:forced_rate, archive: false) }
    let!(:rate) { create(:rate) }

    context "when ForcedRate is not archived" do
      it "assigns the USD rate from the latest ForcedRate to @usd_rate" do
        get :index
        expect(assigns(:usd_rate)).to eq(forced_rate.rate)
      end
    end

    context "when ForcedRate is archived" do
      before { forced_rate.update(archive: true) }

      it "assigns the USD rate from the latest Rate to @usd_rate" do
        get :index
        expect(assigns(:usd_rate)).to eq(rate.rate)
      end
    end

    context "when there are no ForcedRates or Rates" do
      before { ForcedRate.destroy_all; Rate.destroy_all }

      it "assigns nil to @usd_rate" do
        get :index
        expect(assigns(:usd_rate)).to be_nil
      end
    end
  end
end