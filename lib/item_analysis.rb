module ItemAnalysis

  def total_items
    items.all.count.to_f
  end

  def variance_of_average_and_items
    avg = average_items_per_merchant
    merchants.all.map { |merchant| (merchant.items.count - avg) **2 }.inject(:+)
  end

  def variance_of_average_and_items_divided_merchants
    vars_of_avg_div_by_total(variance_of_average_and_items, total_merchants)
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation(variance_of_average_and_items_divided_merchants)
  end

  def sum_of_items
    items.all.reduce(0) { |sum, item| item.unit_price_to_dollars + sum }
  end

  def average_price_of_all_items
    (sum_of_items / total_items).to_f.round(2)
  end

  def variance_of_all_item_prices_from_mean
    avg = average_price_of_all_items
    items.all.map { |item| (item.unit_price_to_dollars.to_f - avg) ** 2 }
  end

  def sum_of_all_item_prices_from_mean
  variance_of_all_item_prices_from_mean.inject(0,:+).round(2)
  end

  def variance_divide_total_items
    variance = sum_of_all_item_prices_from_mean
    (variance/(total_items - 1)).round(2)
  end

  def items_standard_deviation
    standard_deviation(variance_divide_total_items)
  end

  def golden_items
    sd = items_standard_deviation
    avg = average_price_of_all_items
    items.all.select { |i| i if i.unit_price_to_dollars >= (avg + (sd*2)) }
  end
end
