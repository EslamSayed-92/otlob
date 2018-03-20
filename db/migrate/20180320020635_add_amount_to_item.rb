class AddAmountToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :amount, :integer
  end
end
