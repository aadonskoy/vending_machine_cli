# frozen_string_literal: true
require "ostruct"

class ProductsCollection
  def initialize(products = [])
    @collection = products.map do |product|
      OpenStruct.new(name: product[0], price: product[1], quantity: product[2])
    end
  end

  def [](index)
    @collection[index]
  end

  def sell(product)
    @collection.each do |curr_prod|
      next if curr_prod.name != product.name

      raise "can't sell product" if curr_prod.quantity <= 0
      curr_prod.quantity -= 1
      break
    end
  end

  def to_str
    @collection.map.with_index do |product, idx|
      "#{idx + 1}. #{product.name}: $#{product.price} - #{product.quantity} left"
    end.join("\n")
  end
end
