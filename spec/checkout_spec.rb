# frozen_string_literal: true

require "products_collection"
require "coins_collection"
require "order"
require "checkout"

describe Checkout do
  let(:products) do
    ProductsCollection.new([
      ["Water", 0.5, 5],
      ["Juice", 2.25, 3],
      ["Sandwich", 3.0, 0]
    ])
  end
  let(:machine_coins) do
    CoinsCollection.new(
      0.25 => 8, 0.5 => 5, 1.0 => 5, 2.0 => 3, 3.0 => 3, 5.0 => 2
    )
  end

  let(:order) { Order.new(products) }
  let(:checkout) { described_class.new(products, machine_coins, order) }

  describe "try_sell_with_change" do
    it "sell product and return change" do
      order.add_item(1)
      checkout.put_coin(1.0)
      checkout.put_coin(1.0)
      checkout.put_coin(3.0)

      expect(checkout.try_sell_with_change(4.0).coins)
        .to eq(0.25 => 0, 0.5 => 1, 1.0 => 0, 2.0 => 0, 3.0 => 1, 5.0 => 0)
    end
  end
end
