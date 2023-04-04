class CalcChangeService
  MINIMAL_PART = 0.25

  def initialize(machine_coins, amount)
    @machine_coins = machine_coins
    @amount = amount
  end

  def change
    raise "incorrect amount" if @amount % MINIMAL_PART != 0
    return [:error, nil] if @amount > @machine_coins.total

    result = {}
    current_amount = @amount
    coins = @machine_coins.present_coins

    coins.keys.sort.reverse.each do |coin|
      next unless coins[coin].positive? && coin <= current_amount

      req_coins_amount = (current_amount / coin).floor
      if coins[coin] >= req_coins_amount
        result[coin] = req_coins_amount
        current_amount -= coin * req_coins_amount
        coins[coin] -= req_coins_amount
      else
        result[coin] = coins[coin]
        current_amount -= coin * coins[coin]
        coins[coin] = 0
      end
      break if current_amount.zero?
    end

    return [:error, nil] if current_amount.positive?

    [:result, CoinsCollection.new(result)]
  end

  def total_change_amount
    @machine_coins.sum { |k, v| k * v }
  end
end
