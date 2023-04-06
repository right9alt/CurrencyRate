class AddArchiveToForcedRates < ActiveRecord::Migration[7.0]
  def change
    add_column :forced_rates, :archive, :boolean
  end
end
