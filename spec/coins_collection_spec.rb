# frozen_string_literal: true

require "coins_collection"

describe CoinsCollection do
  let(:coins) { CoinsCollection.new(0.25 => 1, 0.5 => 2) }

  describe "initialize" do
    let(:coins) { CoinsCollection.new }

    it "initializes with zero coins" do
      expect(coins.coins).to eq(
        0.25 => 0,
        0.5 => 0,
        1.0 => 0,
        2.0 => 0,
        3.0 => 0,
        5.0 => 0
      )
    end

    it "total is zero" do
      expect(coins.total).to eq(0)
    end
  end

  describe "[]" do
    it "returns the number of coins for a denomination" do
      expect(coins[0.25]).to eq(1)
      expect(coins[0.5]).to eq(2)
    end

    it "errors if the denomination is unknown" do
      expect { coins[0.1] }.to raise_error("unknown 0.1")
    end
  end

  describe "[]=" do
    it "sets the number of coins for a denomination" do
      expect { coins[0.25] = 5 }.to change { coins[0.25] }.from(1).to(5)
    end

    it "errors if the denomination is unknown" do
      expect { coins[0.1] = 5 }.to raise_error("unknown 0.1")
    end
  end

  describe "add_collection" do
    let(:other_coins) { CoinsCollection.new(0.25 => 2, 3.0 => 3) }

    it "adds other coins from other collection" do
      coins.add_collection(other_coins)
      expect(coins[0.25]).to eq(3)
      expect(coins[0.5]).to eq(2)
      expect(coins[3.0]).to eq(3)
    end
  end

  describe "substract_collection" do
    context "when there are enough coins" do
      let(:other_coins) { CoinsCollection.new(0.25 => 1, 3.0 => 3) }

      it "reises and error if there are not enough coins" do
        expect { coins.substract_collection(other_coins) }
          .to raise_error("can't be below zero")
        expect(coins[0.25]).to eq(1)
      end
    end

    context "when coins are enough" do
      let(:other_coins) { CoinsCollection.new(0.25 => 1, 0.5 => 1) }

      it "substracts other coins from existing collection" do
        coins.substract_collection(other_coins)
        expect(coins[0.25]).to eq(0)
        expect(coins[0.5]).to eq(1)
        expect(coins[5.0]).to eq(0)
      end
    end
  end

  describe "add" do
    it "adds coins" do
      expect { coins.add(0.25, 2) }.to change { coins[0.25] }.from(1).to(3)
      expect { coins.add(5.0) }.to change { coins[5.0] }.from(0).to(1)
    end

    it "errors if the denomination is unknown" do
      expect { coins.add(0.1) }.to raise_error("unknown 0.1")
    end
  end
end
