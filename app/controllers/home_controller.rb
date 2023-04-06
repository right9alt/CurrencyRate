class HomeController < ApplicationController
  def index
    if ForcedRate.last&.archive == false
      @usd_rate = ForcedRate.last.rate
    else
      @usd_rate = Rate.last.rate
    end
  end
end
