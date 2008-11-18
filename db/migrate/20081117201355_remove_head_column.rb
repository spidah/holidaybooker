class RemoveHeadColumn < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.remove :head
    end
  end

  def self.down
    change_table :users do |t|
      t.boolean :head, :default => false
    end
  end
end
