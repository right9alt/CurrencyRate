require 'rails_helper'
require 'factory_bot_rails' 

RSpec.describe ForcedRatesController, type: :controller do
  include FactoryBot::Syntax::Methods
  describe "GET #show" do
    it "renders the show template" do
      get :show
      expect(response).to render_template(:show)
    end

    it "assigns @forced_rates" do
      forced_rate1 = create(:forced_rate)
      forced_rate2 = create(:forced_rate)
      get :show
      expect(assigns(:forced_rates)).to match_array([forced_rate1, forced_rate2])
    end

    it "assigns a new @forced_rate" do
      get :show
      expect(assigns(:forced_rate)).to be_a_new(ForcedRate)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "saves a new forced_rate" do
        expect {
          post :create, params: { forced_rate: attributes_for(:forced_rate) }
        }.to change(ForcedRate, :count).by(1)
      end
  
      it "calls ForcedRateService" do
        expect(ForcedRateService).to receive(:call)
        post :create, params: { forced_rate: attributes_for(:forced_rate) }
      end
  
      it "redirects to root path with notice" do
        post :create, params: { forced_rate: attributes_for(:forced_rate) }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present
      end
    end
  
    context "with invalid parameters" do
      it "does not save a new forced_rate" do
        expect {
          post :create, params: { forced_rate: attributes_for(:forced_rate, rate: nil) }
        }.not_to change(ForcedRate, :count)
      end
  
      it "redirects to referrer" do
        request.env["HTTP_REFERER"] = "/some_path"
        post :create, params: { forced_rate: attributes_for(:forced_rate, rate: nil) }
        expect(response).to redirect_to("/some_path")
      end
    end
  end
  
end
