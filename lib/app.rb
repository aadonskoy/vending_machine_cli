# frozen_string_literal: true

require "./products_collection"
require "./coins_collection"
require "./calc_change_service"
require "./order"
require "./checkout"

class App 
  class << self
    def run
      state = :order
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
        puts "\n0. Exit"

        option = gets.chomp.to_i
        break if option == 0
        if state == :order
          order = Order.new(products)
          case order.add_item(option)
          in [:ok]
            state = :checkout
          in [:error, message]
            error_message = message
          end
        end

        if state == :checkout
          Checkout.new(products, machine_coins, order.selected).process
          state = :order
        end

        puts error_message
      end
    end
  end
end

App.run