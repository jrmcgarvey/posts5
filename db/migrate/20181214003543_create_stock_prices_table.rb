class CreateStockPricesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :stock_prices do |t|
      t.string :company
      t.string :ticker
      t.datetime :timestamp
      t.decimal :price
    end
  end
end
