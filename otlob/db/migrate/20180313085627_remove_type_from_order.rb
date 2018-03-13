class RemoveTypeFromOrder < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :type, :integer
  end
end
