class CreateUserTables < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :firstname, :surname
      t.string :crypted_password, :salt, :limit => 40
      t.timestamps
    end

    create_table :roles do |t|
      t.string :name
    end

    create_table :rights do |t|
      t.string :name, :controller, :action
    end

    create_table :roles_users, :id => false do |t|
      t.integer :role_id, :user_id
    end

    create_table :rights_roles, :id => false do |t|
      t.integer :right_id, :role_id
    end
  end

  def self.down
    drop_table :users
    drop_table :roles
    drop_table :rights
    drop_table :roles_users
    drop_table :rights_roles
  end
end
