class AddDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string :name
    end

    change_table :users do |t|
      t.belongs_to :department
      t.boolean :head
    end
  end

  def self.down
    drop_table :departments

    change_table :users do |t|
      t.remove :department_id
      t.remove :head
    end
  end
end
