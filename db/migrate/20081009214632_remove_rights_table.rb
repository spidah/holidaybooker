class RemoveRightsTable < ActiveRecord::Migration
  def self.up
    drop_table :rights
    drop_table :rights_roles

    Role.find(:all).each { |role|
      role.name = role.name.downcase
      role.save
    }
  end

  def self.down
    create_table :rights do |t|
      t.string :name, :controller, :action
    end

    create_table :rights_roles, :id => false do |t|
      t.integer :right_id, :role_id
    end
  end
end
