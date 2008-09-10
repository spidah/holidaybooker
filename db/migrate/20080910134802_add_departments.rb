class AddDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string :name
    end

    create_table :departments_users, :id => false do |t|
      t.integer :department_id, :user_id
    end

    create_table :departments_heads, :id => false do |t|
      t.integer :department_id, :user_id
    end
  end

  def self.down
    drop_table :departments_heads
    drop_table :departments_users
    drop_table :departments
  end
end
