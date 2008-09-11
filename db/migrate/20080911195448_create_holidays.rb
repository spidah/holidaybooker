class CreateHolidays < ActiveRecord::Migration
  def self.up
    create_table :holidays do |t|
      t.date :start_date, :end_date
      t.integer :total_days
      t.string :reason
      t.boolean :confirmed
      t.timestamps
    end
  end

  def self.down
    drop_table :holidays
  end
end
