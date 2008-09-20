class CreateHolidays < ActiveRecord::Migration
  def self.up
    create_table :holidays do |t|
      t.integer :user_id
      t.date :start_date, :end_date
      t.integer :total_days
      t.text :reason
      t.boolean :confirmed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :holidays
  end
end
