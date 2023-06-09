# frozen_string_literal: true

require "./lib/products_collection"
require "./lib/coins_collection"
require "./lib/order"
require "./lib/checkout"

class App 
  class << self
    def run
      state = :order
      products = ProductsCollection.new(
        [
          ["Cola", 2.0, 7],
          ["Chips", 2.25, 4],
          ["Candy", 1.75, 4],
          ["Water", 0.5, 5],
          ["Juice", 2.25, 3],
          ["Sandwich", 3.0, 2]
        ]
      )
      machine_coins = CoinsCollection.new(
        0.25 => 8,
        0.5 => 5,
        1.0 => 5,
        2.0 => 3,
        3.0 => 3,
        5.0 => 2
      )

      puts "\n"
      puts "\e[32m~~== Vending Machine ==~~\e[0m\n"

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
          Checkout.new(products, machine_coins, order).process
          state = :order
        end

        puts error_message
      end
    end
  end
end
