require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_analyst'
require './lib/sales_engine'

class SalesAnalystTest < Minitest::Test
  attr_reader :se_hash, :se, :sa

  def setup
    se_hash = {:items => './data/test_items.csv',
            :merchants => './data/test_merchant.csv',
             :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    @sa = SalesAnalyst.new(se)
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
    assert_equal 1.0, sa.variance_divided_merchants
  end

  def test_average_items_per_merchant_standard_deviation
    assert_equal 1.0, sa.average_items_per_merchant_standard_deviation
  end

  def test_merchants_with_low_item_count_returns_instance_of_merchants
    se_hash = { :items => './data/test_items_sd.csv',
                :merchants => './data/test_merchant_sd.csv',
                :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    sa = SalesAnalyst.new(se)
    low_item = sa.merchants_with_low_item_count
    assert low_item.first.instance_of?(Merchant)
  end

  def test_merchants_with_low_item_count
    se_hash = {:items => './data/test_items_sd.csv',
            :merchants => './data/test_merchant_sd.csv',
            :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    sa = SalesAnalyst.new(se)
    assert_equal 1, sa.merchants_with_low_item_count.count
  end

  def test_average_price_for_merchant
    se_hash = {:items => './data/test_items_sd.csv',
            :merchants => './data/test_merchant_sd.csv',
            :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    sa = SalesAnalyst.new(se)
    assert_equal 705.24, sa.average_item_price_for_merchant(1)
  end

  def test_average_price_per_merchant
    se_hash = {:items => './data/test_items_sd.csv',
            :merchants => './data/test_merchant_sd.csv',
            :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    sa = SalesAnalyst.new(se)
    assert_equal 439.20, sa.average_price_per_merchant
    assert_equal BigDecimal, sa.average_price_per_merchant.class
  end

  def test_average_price_of_all_items
    se_hash = {:items => './data/test_items_sd.csv',
            :merchants => './data/test_merchant_sd.csv',
            :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    sa = SalesAnalyst.new(se)
    assert_equal 533.31, sa.average_price_of_all_items
  end

  def test_variance_of_all_item_prices_from_mean
    se_hash = {:items => './data/test_items_sd.csv',
            :merchants => './data/test_merchant_sd.csv',
            :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    sa = SalesAnalyst.new(se)
    # items_variance = variance_of_all_item_prices_from_mean
    assert_equal 4326479.81, sa.variance_of_all_item_prices_from_mean
  end

  def test_items_variance_divide_total_items
    se_hash = {:items => './data/test_items_sd.csv',
            :merchants => './data/test_merchant_sd.csv',
            :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    sa = SalesAnalyst.new(se)

    assert_equal 77258.57, sa.variance_divide_total_items
  end

  def test_items_standard_deviation_returns_sd_in_big_d
    se_hash = {:items => './data/test_items_sd.csv',
            :merchants => './data/test_merchant_sd.csv',
            :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    sa = SalesAnalyst.new(se)

    assert_equal 277.95, sa.items_standard_deviation
  end

  def test_golden_items_returns_item_object_instance
    se_hash = {:items => './data/test_items_sd.csv',
            :merchants => './data/test_merchant_sd.csv',
            :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    sa = SalesAnalyst.new(se)

    assert sa.golden_items[0].instance_of?(Item)
  end

  def test_golden_items_returns_items_two_sd_above_avg
    se_hash = {:items => './data/test_items_sd.csv',
            :merchants => './data/test_merchant_sd.csv',
            :invoices => './data/test_invoices.csv'}
    se = SalesEngine.new(se_hash)
    sa = SalesAnalyst.new(se)

    assert_equal 1, sa.golden_items.count
  end

  def test_average_invoices_per_merchant
    assert_equal 3.8, sa.average_invoices_per_merchant
  end

  def test_total_invoices_returned
    assert_equal 9, sa.total_invoices_with_common_status(:shipped)
  end

  def test_invoice_status_returns_percentage_of_invoices_with_shipped_status
    assert_equal 47.4, sa.invoice_status(:shipped)
  end

  def test_invoice_status_returns_percentage_of_invoices_with_pending_status
    assert_equal 47.4, sa.invoice_status(:pending)
  end

  def test_invoice_status_returns_percentage_of_invoices_with_returned_status
    assert_equal 5.3, sa.invoice_status(:returned)
  end

  def test_invoice_status_returns_zero_of_invoices_with_other_status
    assert_equal 0.0, sa.invoice_status(:other)
  end
end
