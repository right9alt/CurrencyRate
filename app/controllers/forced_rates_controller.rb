class ForcedRatesController < ApplicationController
  
  def show
    @forced_rates = ForcedRate.all.order(until_time: :desc)
    @forced_rate = ForcedRate.new
  end

  def create
    @forced_rate = ForcedRate.new(forced_rate_params)

    if @forced_rate.save
      ForcedRateService.call(@forced_rate)
      redirect_to root_path, notice: "Курс успешно изменен"
    else
      flash.now[:alert] = "Ошибка при сохранении курса"
      render :form, locals: { forced_rates: ForcedRate.all.order(until_time: :desc), forced_rate: ForcedRate.new }
    end
  end
  
  private
  def forced_rate_params
    params.require(:forced_rate).permit(:rate, :until_time, :archive)
  end
end