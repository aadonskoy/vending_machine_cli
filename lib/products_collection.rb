# frozen_string_literal: true
require "ostruct"

class ProductsCollection
  DEFAULT_PRODUCTS = [
    ["Cola", 2.0, 7],
    ["Chips", 2.25, 4],
    ["Candy", 1.75, 4],
    ["Water", 0.5, 5],
    ["Juice", 2.25, 3],
    ["Sandwich", 3.0, 2]
  ].freeze

  def initialize(products = nil)
    products ||= DEFAULT_PRODUCTS

    @collection = products.map do |product|
      OpenStruct.new(name: product[0], price: product[1], quantity: product[2])
    end
  end

  def [](index)
    @collection[index]
  end

  def sell(product)
    @collection.each do |curr_prod|
      curr_prod.quantity -= 1 if curr_prod.name == product.name
    end
  end

  def to_str
    @collection.map.with_index do |product, idx|
      "#{idx}. #{product.name}: $#{product.price} - #{product.quantity} left"
    end.join("\n")
  end
end
