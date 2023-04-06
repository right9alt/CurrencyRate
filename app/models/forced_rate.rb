class ForcedRate < ApplicationRecord
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :until_time, presence: true
  validate :until_time_on_or_after_current_time

  private

  def until_time_on_or_after_current_time
    errors.add(:until_time, "Время должно быть текущим или более поздним") if until_time.present? && until_time < Time.current
  end
end
