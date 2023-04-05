# frozen_string_literal: true

class CoinsCollection
  attr_reader :coins

  def initialize(collection = {})
    @coins = {
      0.25 => 0,
      0.5 => 0,
      1.0 => 0,
      2.0 => 0,
      3.0 => 0,
      5.0 => 0
    }.merge(collection)
  end

  def [](denominate)
    raise "unknown #{denominate}" unless coins.key?(denominate.to_f)

    coins[denominate.to_f]
  end

  def []=(denominate, value)
    raise "unknown #{denominate}" unless coins.key?(denominate.to_f)

    coins[denominate.to_f] = value
  end

  def add_collection(coins_collection)
    @coins.each do |k, _|
      coins[k] += coins_collection[k]
    end
  end

  def substract_collection(coins_collection)
    new_coins = coins.dup
    @coins.each do |k, _|
      raise "can't be below zero" if new_coins[k] < coins_collection[k]

      new_coins[k] -= coins_collection[k]
    end

    @coins = new_coins
  end

  def add(denomination, count = 1)
    raise "unknown #{denomination}" unless coins.key?(denomination.to_f)

    @coins[denomination.to_f] += count
  end

  def present_coins
    coins.select { |_, v| v.positive? }
  end

  def total
    coins.sum { |k, v| k * v }
  end

  def denominates
    @coins.keys
  end

  def denominates_to_str
    denominates.map.with_index do |den, idx|
      "#{idx + 1}. #{den}"
    end.join("\n")
  end

  def coins_to_str(full_collection = true)
    show_coins = full_collection ? coins : present_coins
    show_coins.map { |k, v| "#{k}: #{v}" }.join("\n")
  end

  def coin_by_id(coin_id)
    denominates[coin_id]
  end

  def present?
    coins.any?
  end
end
