class AddRejectionStuffToHolidays < ActiveRecord::Migration
  def self.up
    change_table :holidays do |t|
      t.boolean :rejected, :default => false
      t.text :rejected_reason
    end
  end

  def self.down
    change_table :holidays do |t|
      t.remove :rejected
      t.remove :rejected_reason
    end
  end
end
