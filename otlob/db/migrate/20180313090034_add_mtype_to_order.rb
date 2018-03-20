class AddMtypeToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :mtype, :integer
  end
end
