#frozen_string_literal: true

class Order
  attr_reader :selected

  def initialize(products)
    @products = products
    @selected = nil
  end

  def add_item(product_id)
    product = @products[product_id - 1]

    return [:error, "No product with id #{product_id}"] if product.nil?
    return [:error, "Product is out of stock"] if product.quantity.zero?

    @selected = product
    [:ok]
  end
end
