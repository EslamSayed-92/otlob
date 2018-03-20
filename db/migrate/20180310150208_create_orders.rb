class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :type
      t.string :restaurant

      t.timestamps
    end
  end
end
