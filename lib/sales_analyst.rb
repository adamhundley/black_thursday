class SalesAnalyst
attr_reader :sales_engine, :items, :merchants, :invoices, :invoice_items, :transactions, :customers

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @items = sales_engine.items
    @merchants = sales_engine.merchants
    @invoices = sales_engine.invoices
    @invoice_items = sales_engine.invoice_items
    @transactions = sales_engine.transactions
    @customers = sales_engine.customers
  end

  def total_merchants
    merchants.all.count.to_f
  end

  def total_items
    items.all.count.to_f
  end

  def total_invoices
    invoices.all.count.to_f
  end

  def average_calculator(numerator, denominator)
    (numerator/denominator).round(2)
  end

  def variances_of_averages_divided_by_totals(variance, total)
    (variance/(total - 1)).round(2)
  end

  def average_items_per_merchant
    average_calculator(total_items, total_merchants)
  end

  def variance_of_average_and_items
    avg = average_items_per_merchant
    merchants.all.map { |merchant| (merchant.items.count - avg) **2 }.inject(:+)
  end

  def variance_of_average_and_items_divided_merchants
    variances_of_averages_divided_by_totals(variance_of_average_and_items, total_merchants)
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation(variance_of_average_and_items_divided_merchants)
  end

  def merchants_with_high_item_count
    sd = average_items_per_merchant_standard_deviation
    avg = average_items_per_merchant
    merchants.all.map { |merchant| merchant if merchant.items.count >= avg + sd }.compact
  end

  def average_item_price_for_merchant(merchant_id)
      found_items = items.find_all_by_merchant_id(merchant_id)
      count = found_items.count
      if count > 0
        (found_items.reduce(0) { |sum, item| item.unit_price + sum } / count).round(2)
      end
  end

  def average_average_price_per_merchant
    avg = merchants.all.map { |merchant| average_item_price_for_merchant(merchant.id)}.compact
    (avg.inject(:+)/total_merchants).round(2)
  end

  def average_price_of_all_items
    (items.all.reduce(0) { |sum, item| item.unit_price + sum}/total_items).to_f.round(2)
  end

  def variance_of_all_item_prices_from_mean
    avg = average_price_of_all_items
    (items.all.map { |item| (item.unit_price.to_f - avg) ** 2 }.inject(:+)).round(2)
  end

  def variance_divide_total_items
    variance = variance_of_all_item_prices_from_mean
    (variance/(total_items - 1)).round(2)
  end

  def standard_deviation(final_variance_calculation)
    Math.sqrt(final_variance_calculation).round(2)
  end

  def items_standard_deviation
    standard_deviation(variance_divide_total_items)
  end

  def golden_items
    sd = items_standard_deviation
    avg = average_price_of_all_items
    items.all.map { |item| item if item.unit_price >= (avg + (sd*2)) }.compact
  end

  def average_invoices_per_merchant
    average_calculator(total_invoices, total_merchants)
  end

  def variance_of_average_and_invoices
    avg = average_invoices_per_merchant
    merchants.all.map { |merchant| (merchant.invoices.count - avg) **2 }.inject(:+)
  end

  def variance_of_average_and_invoices_divided_merchants
    variances_of_averages_divided_by_totals(variance_of_average_and_invoices, total_merchants)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(variance_of_average_and_invoices_divided_merchants)
  end

  def total_invoices_with_common_status(status)
    invoices.all.map { |invoice| invoice if invoice.status == status }.compact.count
  end

  def invoice_status(status)
    ((total_invoices_with_common_status(status)/total_invoices) * 100).round(2)
  end

  def average_invoices_of_all_merchants
    (merchants.all.reduce(0) { |sum, merchant| merchant.invoices.count + sum}/total_merchants).to_f.round(2)
  end

  def top_merchants_by_invoice_count
    sd = average_invoices_per_merchant_standard_deviation
    avg = average_invoices_per_merchant
    merchants.all.map { |merchant| merchant if merchant.invoices.count >= (avg + (sd * 2)) }.compact
  end

  def bottom_merchants_by_invoice_count
    sd = average_invoices_per_merchant_standard_deviation
    avg = average_invoices_per_merchant
    merchants.all.map { |merchant| merchant if merchant.invoices.count <= (avg - (sd * 2)) }.compact
  end

  def day_of_invoice
    invoices.all.map { |invoice| invoice.created_at.strftime("%A").to_sym }
  end

  def group_invoices_by_day
    day_of_invoice.group_by { |day| day }
  end

  def count_invoices_by_day
    group_invoices_by_day.map { |k, v| [k, v.count] }.to_h
  end

  def average_invoices_per_day
    average_calculator(total_invoices, 7)
  end

  def variance_of_invoices_per_day_from_average_squared
    avg = average_invoices_per_day
    count_invoices_by_day.values.map { |v| ((v - avg) ** 2) }.inject(:+).round(2)
  end

  def variance_divided_by_total_invoices
    variance = variance_of_invoices_per_day_from_average_squared
    total = 7
    variances_of_averages_divided_by_totals(variance, total)
  end

  def sd_of_invoices_per_day
    standard_deviation(variance_divided_by_total_invoices)
  end

  def top_days_by_invoice_count
    sd = sd_of_invoices_per_day
    avg = average_invoices_per_day
    count_invoices_by_day.map { |day , value| day if value > (avg + sd) }.compact
  end


end
