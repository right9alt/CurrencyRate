class CreateRateService

  URL = "https://www.cbr.ru/scripts/XML_daily.asp"
  def self.call(...)
    new(...).call
  end

  def initialize
    @response = HTTParty.get(URL)
  end

  def call
    fetch_usd_rate
    save_rate
  end

  def fetch_usd_rate
    xml_doc = Nokogiri::XML(@response.body)
    rate = xml_doc.xpath("//Valute[@ID='R01235']/Value")
    @usd_rate = rate.text.gsub(',','.').to_f
  end

  def save_rate
    Rate.create(rate: @usd_rate)
  end
end