class CreateForcedRates < ActiveRecord::Migration[7.0]
  def change
    create_table :forced_rates do |t|
      t.float :rate
      t.datetime :until_time

      t.timestamps
    end
  end
end
