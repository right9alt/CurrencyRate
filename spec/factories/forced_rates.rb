FactoryBot.define do
  factory :forced_rate do
    rate { 61.23 } # Пример значения атрибута
    until_time { Time.now + 1.day } # Пример значения атрибута
    archive { false } # Пример значения атрибута
  end
end