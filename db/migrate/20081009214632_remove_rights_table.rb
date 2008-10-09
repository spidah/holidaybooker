class RemoveRightsTable < ActiveRecord::Migration
  def self.up
    drop_table :rights
    drop_table :rights_roles
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
