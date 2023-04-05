# frozen_string_literal: true

require "order"

describe Order do
  let(:products) do
    ProductsCollection.new([
      ["Water", 0.5, 5],
      ["Juice", 2.25, 3],
      ["Sandwich", 3.0, 0]
    ])
  end

  subject(:order) { described_class.new(products) }

  describe "add_item" do
    it "returns ok and sets selected product" do
      expect(order.add_item(1)).to eq([:ok])
      expect(order.selected.name).to eq("Water")
    end

    it "returns error and sets error message if product is out of stock" do
      expect(order.add_item(3)).to eq([:error, "Product is out of stock"])
      expect(order.selected).to be_nil
    end
  end
end
