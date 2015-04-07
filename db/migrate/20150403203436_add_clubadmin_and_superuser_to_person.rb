class AddClubadminAndSuperuserToPerson < ActiveRecord::Migration
  def change
    add_column :person, :clubadmin, :bool
    add_column :person, :superuser, :bool
  end
end
