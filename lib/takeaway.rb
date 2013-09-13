class Takeaway
  def dishes
    { :tonkatsu => 6, :chashumen => 5, :teriyaki => 4, :edamame => 2 }
  end

  def place_order(dishes_and_quantities, order_total)
    actual_price = check_price_of(dishes_and_quantities)
    raise_order_total_error if actual_price != order_total
    true
  end

  def check_price_of(dishes_and_quantities)
    dishes_and_quantities.inject(0) do |price, (dish, quantity)|
      price += dishes[dish] * quantity
    end
  end

  def raise_order_total_error
    raise ArgumentError, 'Total is wrong. Please place the order again.'
  end
end