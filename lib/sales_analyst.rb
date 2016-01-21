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

  def average_items_per_merchant
    average_calculator(total_items, total_merchants)
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

  def merchants_with_pending_invoices
    merchants.all.select do |merchant|
      merchant if merchant.invoices.any? do |inv|
        !inv.is_paid_in_full?
      end
    end.compact
  end

  def invoices_items(merchants_invoices)
    merchants_invoices.map do |invoice|
      invoice_items.find_all_by_invoice_id(invoice.id)
    end.flatten
  end

  def most_sold_item_for_merchant(merchant_id)
    merchants_invoices = paid_in_full_invoices(find_merchant(merchant_id))
    inv_items = invoices_items(merchants_invoices)
    most_item_quan = inv_items.max_by { |i| i.quantity }.quantity

    all_high_items = inv_items.select do |i|
      i.item_id if i.quantity == most_item_quan
    end
    all_high_items.map { |i| items.find_by_id(i.item_id) }.compact
  end

  def best_item_for_merchant(merchant_id)
    merchant = find_merchant(merchant_id)
    merchants_invoices = paid_in_full_invoices(merchant)
    best_item = invoices_items(merchants_invoices).max_by { |i| i.revenue }
    items.find_by_id(best_item.item_id)
  end

end
