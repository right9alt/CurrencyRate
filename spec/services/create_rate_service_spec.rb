require 'rails_helper'
require 'webmock/rspec'
RSpec.describe CreateRateService, type: :service do
  describe '.call' do
    it 'fetches USD rate from API and saves it to the database' do
      # Создаем заглушку HTTP-ответа для HTTParty
      stub_request(:get, CreateRateService::URL)
        .to_return(
          body: <<-XML
            <ValCurs Date="03/28/2023" name="Foreign Currency Market">
              <Valute ID="R01235">
                <NumCode>840</NumCode>
                <CharCode>USD</CharCode>
                <Nominal>1</Nominal>
                <Name>US Dollar</Name>
                <Value>69.1234</Value>
              </Valute>
              <Valute ID="R01239">
                <NumCode>978</NumCode>
                <CharCode>EUR</CharCode>
                <Nominal>1</Nominal>
                <Name>Euro</Name>
                <Value>79.5678</Value>
              </Valute>
            </ValCurs>
          XML
        )

      # Вызываем сервис
      CreateRateService.call

      # Проверяем, что сервис правильно извлекает курс USD и сохраняет его в базе данных
      expect(Rate.count).to eq(1)
      expect(Rate.first.rate).to eq(69.1234)
    end
  end

  describe '#fetch_usd_rate' do
    it 'fetches USD rate from XML response' do
      # Создаем заглушку HTTP-ответа для HTTParty
      stub_request(:get, CreateRateService::URL)
        .to_return(
          body: <<-XML
            <ValCurs Date="03/28/2023" name="Foreign Currency Market">
              <Valute ID="R01235">
                <NumCode>840</NumCode>
                <CharCode>USD</CharCode>
                <Nominal>1</Nominal>
                <Name>US Dollar</Name>
                <Value>69.1234</Value>
              </Valute>
              <Valute ID="R01239">
                <NumCode>978</NumCode>
                <CharCode>EUR</CharCode>
                <Nominal>1</Nominal>
                <Name>Euro</Name>
                <Value>79.5678</Value>
              </Valute>
            </ValCurs>
          XML
        )

      # Создаем экземпляр сервиса и вызываем метод fetch_usd_rate
      service = CreateRateService.new
      service.send(:fetch_usd_rate)

      # Проверяем, что сервис правильно извлекает курс USD
      expect(service.instance_variable_get(:@usd_rate)).to eq(69.1234)
    end
  end

  describe '#save_rate' do
    it 'saves USD rate to the database' do
      stub_request(:get, "https://www.cbr.ru/scripts/XML_daily.asp")
                  .with(
                    headers: {
                      'Accept'=>'*/*',
                      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                      'User-Agent'=>'Ruby'
                    }
                  ).to_return(status: 200, body: "", headers: {})
      # Создаем экземпляр сервиса и устанавливаем значение @usd_rate
      service = CreateRateService.new
      service.instance_variable_set(:@usd_rate, 69.1234)
     # Вызываем метод save_rate
      service.send(:save_rate)

      # Проверяем, что сервис сохраняет курс USD в базе данных
      expect(Rate.count).to eq(1)
      expect(Rate.first.rate).to eq(69.1234)
    end
  end
end
     
