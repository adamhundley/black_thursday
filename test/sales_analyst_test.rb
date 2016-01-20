require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_analyst'
require './lib/sales_engine'

class SalesAnalystTest < Minitest::Test
  attr_reader :sa, :se, :sasd

  def setup
    se_hash = {:items => './data/test_items.csv',
            :merchants => './data/test_merchant.csv',
            :invoices => './data/test_invoices.csv',
            :invoice_items => './data/test_invoice_items.csv',
            :transactions => './data/test_transactions.csv',
            :customers => './data/test_customers.csv'}
    @se = SalesEngine.new(se_hash)
    @sa = SalesAnalyst.new(se)

    sesd_hash = {:items => './data/test_items_sd.csv',
                :merchants => './data/test_merchant_sd.csv',
                :invoices => './data/test_invoices.csv',
                :invoice_items => './data/test_invoice_items.csv',
                :transactions => './data/test_transactions.csv',
                :customers => './data/test_customers.csv'}

    sesd = SalesEngine.new(sesd_hash)
    @sasd = SalesAnalyst.new(sesd)
  end

  def test_for_instance_of_sales_analyst
    assert sa.instance_of?(SalesAnalyst)
  end

  def test_total_merchants_returns_count_of_all_merchants
    assert_equal 5, sa.total_merchants
  end

  def test_total_items_returns_count_of_all_items
    assert_equal 5, sa.total_items
  end

  def test_average_items_per_merchant
    assert_equal 1, sa.average_items_per_merchant
  end

  def test_variance_of_average_and_times
    assert_equal 4.0, sa.variance_of_average_and_items
  end

  def test_variance_divided_by_merchants
    assert_equal 1.0, sa.variance_of_average_and_items_divided_merchants
  end

  def test_average_items_per_merchant_standard_deviation
    assert_equal 1.0, sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_high_item_count_returns_instance_of_merchants
    high_item = sasd.merchants_with_high_item_count
    assert high_item.first.instance_of?(Merchant)
  end

  def test_merchants_with_high_item_count
    assert_equal 1, sasd.merchants_with_high_item_count.count
  end

  def test_average_price_for_merchant
    assert_equal 705.24, sasd.average_item_price_for_merchant(1)
  end

  def test_average_average_price_per_merchant
    assert_equal 251.79, sa.average_average_price_per_merchant.to_f
    assert_equal BigDecimal, sa.average_average_price_per_merchant.class
  end

  def test_average_price_of_all_items
    assert_equal 533.31, sasd.average_price_of_all_items
  end

  def test_sum_of_all_item_prices_from_mean
    assert_equal 4326479.81, sasd.sum_of_all_item_prices_from_mean
  end

  def test_items_variance_divide_total_items
    assert_equal 77258.57, sasd.variance_divide_total_items
  end

  def test_items_standard_deviation_returns_sd_in_big_d
    assert_equal 277.95, sasd.items_standard_deviation
  end

  def test_golden_items_returns_item_object_instance
    assert sasd.golden_items[0].instance_of?(Item)
  end

  def test_golden_items_returns_items_two_sd_above_avg
    assert_equal 1, sasd.golden_items.count
  end

  def test_average_invoices_per_merchant
    assert_equal 12.2, sa.average_invoices_per_merchant
  end

  def test_total_invoices_returned
    assert_equal 40, sa.total_invoices_with_common_status(:shipped)
  end

  def test_invoice_status_returns_percentage_of_invoices_with_shipped_status
    assert_equal 65.57, sa.invoice_status(:shipped)
  end

  def test_invoice_status_returns_percentage_of_invoices_with_pending_status
    assert_equal 27.87, sa.invoice_status(:pending)
  end

  def test_invoice_status_returns_percentage_of_invoices_with_returned_status
    assert_equal 6.56, sa.invoice_status(:returned)
  end

  def test_invoice_status_returns_zero_of_invoices_with_other_status
    assert_equal 0.0, sa.invoice_status(:other)
  end

  def test_average_invoices_per_merchant_standard_deviation
    assert_equal 4.97, sa.average_invoices_per_merchant_standard_deviation
  end

  def test_top_merchants_by_invoice_count
    assert_equal [], sa.top_merchants_by_invoice_count
  end

  def test_bottom_merchants_by_invoice_count
    assert_equal [], sa.bottom_merchants_by_invoice_count
  end

  def test_day_of_invoices_returns_array_of_all_days

    assert_equal 61, sa.day_of_invoice.count
  end

  def test_group_invoices_by_day_returns_hash_of_arrays
    assert_equal 7, sa.group_invoices_by_day.count
  end

  def test_counts_invoices_by_day_returns_array_of_day_totals
    assert_equal 4, sa.count_invoices_by_day["Friday"]
  end

  def test_average_invoices_per_day_returns_float_of_mean_count
    assert_equal 8.71, sa.average_invoices_per_day
  end

  def test_variance_of_invoices_per_day_from_average_squared_returns_float
    assert_equal 217.43 , sa.variance_of_invoices_per_day_from_average_squared
  end

  def test_variance_divided_by_total_invoices_returns_float
    assert_equal 36.24, sa.variance_divided_by_total_invoices

  end

  def test_sd_of_invoices_per_day_returns_float
    assert_equal 6.02, sa.sd_of_invoices_per_day
  end

  def test_top_days_by_invoice_count_returns_array_of_days_more_than_one_sd_above_mean
    assert_equal 1, sa.top_days_by_invoice_count.count
  end

  def test_paid_in_full_returns_true_when_transaction_status_is_successful
    invoice = se.invoices.find_by_id(1)
    assert_equal true, invoice.is_paid_in_full?
  end

  def test_paid_in_full_returns_false_when_transaction_status_is_failed
    invoice = se.invoices.find_by_id(1752)
    assert_equal false, invoice.is_paid_in_full?
  end

  def test_total_returns_sum_of_all_invoice_items_unit_prices_per_invoice_id
    invoice = se.invoices.find_by_id(1)
    assert_equal 21067.77, invoice.total
  end

  def test_total_returns_sum_of_all_invoice_items_unit_prices_per_invoice_id
    invoice = se.invoices.find_by_id(1)
    assert_equal BigDecimal, invoice.total.class
  end

  def test_total_revenue_by_date_returns_all_revenue_for_a_specifc_date
    date = Time.parse("2012-02-17")
    assert_equal 21067.77, sa.total_revenue_by_date(date).to_f
  end

  def test_total_revenue_by_date_returns_big_decimal_class
    date = Time.parse("2012-02-17")
    assert_equal BigDecimal, sa.total_revenue_by_date(date).class
  end

  def test_total_returns_sum_of_all_invoices_per_merchant
    merchant = se.merchants.find_by_id(1)
    assert_equal 0, merchant.revenue
  end

  def test_top_revenue_earners_returns_array_of_requested_amount
    assert_equal 1, sa.top_revenue_earners(3).count
  end

  def test_top_revenue_earners_returns_array_of_merchant_instances
    assert_equal Merchant, sa.top_revenue_earners(5)[0].class
  end

  def test_merchants_with_pending_invoices_returns_an_array_of_merchants
    assert_equal 5, sa.merchants_with_pending_invoices.count
  end

  def test_merchants_with_pending_invoice_returns_merchant_instances
    assert_equal Merchant, sa.merchants_with_pending_invoices[0].class
  end

  def test_merchants_with_only_one_item_count_returns_an_array_of_merchants
    assert_equal 5, sa.merchants_with_only_one_item.count
  end

  def test_merchants_with_only_one_item_count_returns_an_array_of_merchants
    assert_equal Merchant, sa.merchants_with_only_one_item[0].class
  end

  def test_merchants_with_only_one_item_registered_in_month_returns_merchants
    assert_equal 1, sa.merchants_with_only_one_item_registered_in_month("March").count
  end
#################### FIX BELOW TEST
  def test_revenue_by_merchant_gives_total_revenue
    assert_equal 0, sa.revenue_by_merchant(3).to_f
  end
#########

  def test_most_sold_item_for_merchant_returns_an_instance_of_item
    skip

    assert_equal Item, sa.most_sold_item_for_merchant(1).class
  end

  def test_best_item_for_merchant_returns_item_with_most_revenue
    skip
    
    assert_equal Item, sa.best_item_for_merchant(1).class
  end

end
