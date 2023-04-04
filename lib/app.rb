# frozen_string_literal: true

require "./products_collection"
require "./coins_collection"
require "./calc_change_service"

class Checkout
  def initialize(products, machine_coins, product)
    @products = products
    @product = product
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

  def process
    greeting

    loop do
      coin_id = gets.chomp.to_i
      put_coin(coin_id)
      puts "Total: #{@user_coins.total}"

      @user_total = @user_coins.total
      if @user_total >= @product.price
        change_total = @user_total - @product.price
        change = CalcChangeService.new(@machine_coins, change_total).change
        if change[0] == :result
          @machine_coins.substract_collection(change[1])
          @products.sell(@product)
          @machine_coins.add_collection(@user_coins)
          puts "*** Thank you! You've bought #{@product.name} ***"
          puts "Your change:"
          puts change[1].coins_to_str
        else
          no_change_message
        end
        break
      end
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
end

products = ProductsCollection.new
machine_coins = CoinsCollection.new(
  0.25 => 8,
  0.5 => 5,
  1.0 => 5,
  2.0 => 3,
  3.0 => 3,
  5.0 => 2
)

puts "\n"
puts "~~== Vending Machine ==~~\n"

loop do
  puts "\nSelect an item:"
  puts products.to_str
  puts "\n9. Exit"

  option = gets.chomp
  break if option.to_i == 9

  product = products[option.to_i]
  if product && product.quantity == 0
    puts "Sorry, #{product.name} is out of stock\n"
    next
  end

  Checkout.new(products, machine_coins, product).process if product
end
