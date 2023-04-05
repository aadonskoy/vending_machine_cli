require "products_collection"

describe ProductsCollection do
  let(:custom_collection) do
    ProductsCollection.new([["Water", 0.5, 5], ["Milk", 2.0, 2]])
  end

  describe "#initialize with default products" do
    subject { ProductsCollection.new }

    it { expect(subject[0].name).to eq("Cola") }
    it { expect(subject[1].quantity).to eq(4) }
    it { expect(subject[3].price).to eq(0.5) }
  end

  describe "#initialize with custom products" do
    subject { custom_collection }

    it { expect(subject[0].name).to eq("Water") }
    it { expect(subject[1].quantity).to eq(2) }
  end

  describe "#to_str" do
    subject { custom_collection.to_str }

    it do
      expect(subject).to eq("1. Water: $0.5 - 5 left\n2. Milk: $2.0 - 2 left")
    end
  end
end
