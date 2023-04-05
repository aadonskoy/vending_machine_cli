require "products_collection"

describe ProductsCollection do
  let(:collection) do
    ProductsCollection.new([["Water", 0.5, 5], ["Milk", 2.0, 2]])
  end

  describe "initialize with no products" do
    subject { ProductsCollection.new }

    it { expect(subject[0]).to  be_nil}
  end

  describe "initialize with products" do
    subject { collection }

    it { expect(subject[0].name).to eq("Water") }
    it { expect(subject[1].quantity).to eq(2) }
  end

  describe "[]" do
    it { expect(collection[0].name).to eq("Water") }
    it { expect(collection[10]).to be_nil }
  end

  describe "to_str" do
    subject { collection.to_str }

    it { expect(subject).to eq("1. Water: $0.5 - 5 left\n2. Milk: $2.0 - 2 left") }
  end

  describe "sell" do
    let(:collection) do
      ProductsCollection.new(
        [
          ["Water", 0.5, 5],
          ["Milk", 2.0, 2],
          ["Candy", 1.0, 0]
        ]
      )
    end

    it "decreases the quantity of the product" do
      expect { collection.sell(collection[0]) }
        .to change { collection[0].quantity }.from(5).to(4)
    end


    it "raises an error if the product is out of stock" do
      expect { collection.sell(collection[2]) }
      .to raise_error("can't sell product")
    end
  end
end
