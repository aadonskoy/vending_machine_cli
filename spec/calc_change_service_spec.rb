# frozen_string_literal: true

require "coins_collection"
require "calc_change_service"

describe CalcChangeService do
  let(:existing_coins) do
    CoinsCollection.new(
      0.25 => 0,
      0.5 => 0,
      1.0 => 0,
      2.0 => 0,
      3.0 => 0,
      5.0 => 0
    )
  end

  it "returns true if there is change" do
    existing_coins.add(0.25, 1)
    existing_coins.add(0.5, 2)
    existing_coins.add(5.0, 1)
    expect(CalcChangeService.new(existing_coins, 1.0).change[0])
      .to eq(:result)
    expect(CalcChangeService.new(existing_coins, 1.0).change[1][0.5])
      .to eq(2)
    expect(CalcChangeService.new(existing_coins, 10.25).change[0])
      .to eq(:error)
  end

  it "raises an error if the amount is not a multiple of 0.25" do
    expect { CalcChangeService.new(existing_coins, 0.26).change }
      .to raise_error("incorrect amount")
  end
end
