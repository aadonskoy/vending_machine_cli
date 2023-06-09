# frozen_string_literal: true
require "./lib/calc_change_service"

class Checkout
  def initialize(products, machine_coins, order)
    @products = products
    @product = order.selected
    @machine_coins = machine_coins
    @user_coins = CoinsCollection.new
  end

  def greeting
    puts "You selected: #{@product.name} with price: #{@product.price}"
    puts "Choose coin to put in the machine:"
    puts @user_coins.denominates_to_str
  end

  def no_change_message
    puts "Sorry, we don't have change for this amount"
    puts "Please take your money back"
    puts "Total: #{@user_coins.total}"
  end

  def user_change_message(change)
    return unless change.total.positive?

    puts "Your change:"
    puts change.coins_to_str(false)
  end

  def process
    greeting

    loop do
      coin_id = gets.chomp.to_i
      put_coin(coin_id - 1)

      user_total = @user_coins.total
      puts "Your coins total: #{user_total}"
      next unless user_total >= @product.price

      if (change = try_sell_with_change(user_total))
        puts "\n*** Thank you! You've bought #{@product.name} ***"
        user_change_message(change)
      else
        no_change_message
      end
      break
    end
  end

  def put_coin(coin_id)
    coin = @user_coins.coin_by_id(coin_id)
    if coin.nil?
      puts "Incorrect coin. Please choose again"
      return
    end

    @user_coins.add(coin)
  end

  def try_sell_with_change(user_total)
    change_total = user_total - @product.price
    change = CalcChangeService.new(@machine_coins, change_total).change

    if change[0] == :result
      @machine_coins.substract_collection(change[1])
      @products.sell(@product)
      @machine_coins.add_collection(@user_coins)
      change[1]
    else
      no_change_message
      false
    end
  end
end
