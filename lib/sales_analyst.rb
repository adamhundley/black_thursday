require 'calculations'
require 'merchant_analysis'
require 'invoice_analysis'
require "item_analysis"

class SalesAnalyst
attr_reader :sales_engine, :items, :merchants, :invoices,
            :invoice_items, :transactions, :customers
include Calculations
include MerchantAnalysis
include InvoiceAnalysis
include ItemAnalysis

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

  def merchants_with_high_item_count
    sd = average_items_per_merchant_standard_deviation
    avg = average_items_per_merchant
    merchants.all.select do |merchant|
      merchant if merchant.items.count >= avg + sd
    end
  end

  def average_item_price_for_merchant(merchant_id)
    found = items.find_all_by_merchant_id(merchant_id)
    count = found.count
    if count > 0
      (found.reduce(0) { |s, i| i.unit_price_to_dollars + s }/count).round(2)
    end
  end

  def average_average_price_per_merchant
    avg = merchants.all.map { |merchant|
    average_item_price_for_merchant(merchant.id)}.compact
    (avg.inject(:+)/total_merchants).round(2)
  end



  def average_invoices_per_merchant
    average_calculator(total_invoices, total_merchants)
  end

  def variance_of_average_and_invoices
    avg = average_invoices_per_merchant
    merchants.all.map { |merch| (merch.invoices.count - avg) **2 }.inject(:+)
  end

  def variance_of_average_and_invoices_divided_merchants
    vars_of_avg_div_by_total(variance_of_average_and_invoices, total_merchants)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(variance_of_average_and_invoices_divided_merchants)
  end

  def total_invoices_with_common_status(status)
    invoices.all.map { |inv| inv if inv.status == status }.compact.count
  end

  def invoice_status(status)
    ((total_invoices_with_common_status(status)/total_invoices) * 100).round(2)
  end

  def average_invoices_of_all_merchants
    sums = merchants.all.reduce(0) { |sum, merch| merch.invoices.count + sum}
    (sums/total_merchants).to_f.round(2)
  end

  def top_merchants_by_invoice_count
    sd = average_invoices_per_merchant_standard_deviation
    avg = average_invoices_per_merchant
    merchants.all.map do |merch|
       merch if merch.invoices.count >= (avg + (sd * 2))
     end.compact
  end

  def bottom_merchants_by_invoice_count
    sd = average_invoices_per_merchant_standard_deviation
    avg = average_invoices_per_merchant
    merchants.all.map do |merch|
      merch if merch.invoices.count <= (avg - (sd * 2))
    end.compact
  end

  def day_of_invoice
    invoices.all.map { |invoice| invoice.created_at.strftime("%A") }
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
    count_invoices_by_day.values.map { |v| (v - avg) ** 2 }.inject(:+).round(2)
  end

  def variance_divided_by_total_invoices
    variance = variance_of_invoices_per_day_from_average_squared
    total = 7
    vars_of_avg_div_by_total(variance, total)
  end

  def sd_of_invoices_per_day
    standard_deviation(variance_divided_by_total_invoices)
  end

  def top_days_by_invoice_count
    sd = sd_of_invoices_per_day
    avg = average_invoices_per_day
    count_invoices_by_day.map { |day , val| day if val > (avg + sd) }.compact
  end

  def invoice_items_for_a_specific_date(date)
    day = date.strftime("%F")
    invoices.all.map do |inv|
      inv.total if inv.created_at.strftime("%F") == day && inv.is_paid_in_full?
    end.compact.flatten
  end

  def total_revenue_by_date(date)
    totals = invoice_items_for_a_specific_date(date)
    totals.inject(0, :+)
  end

  def earning_merchants
    merchants.all.reject { |merch| merch.revenue == nil || merch.revenue == 0 }
  end

  def merchants_ranked_by_revenue
    earning_merchants.sort_by { |merchant| merchant.revenue}.reverse
  end

  def top_revenue_earners(num = 20)
    merchants_ranked_by_revenue[0..(num-1)]
  end

  def merchants_with_pending_invoices
    merchants.all.select do |merchant|
      merchant if merchant.invoices.any? do |inv|
        !inv.is_paid_in_full?
      end
    end.compact
  end

  def merchants_with_only_one_item
    merchants.all.map { |merch| merch if merch.items.count == 1 }.compact
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.map do |merch|
      merch if merch.created_at.strftime("%B") == month
    end.compact
  end

  def revenue_by_merchant(merchant_id)
    merchant = merchants.find_by_id(merchant_id)
    merchant.revenue
  end

  def most_sold_item_for_merchant(merchant_id)
    merchant = merchants.find_by_id(merchant_id)
    merchants_invoices = merchant.invoices
    invoices_items = merchants_invoices.map { |invoice| invoice_items.find_all_by_invoice_id(invoice.id)}.flatten
    inv_item =invoices_items.max_by { |i| i.quantity }
    items.find_by_id(inv_item.item_id)
  end

  # def best_item_for_merchant(merchant_id)
  #
  # end
end
