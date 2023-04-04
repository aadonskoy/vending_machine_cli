# frozen_string_literal: true

require "coins_collection"

describe CoinsCollection do
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
