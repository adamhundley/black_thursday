require 'minitest/autorun'
require 'minitest/pride'
require './lib/finder'

class FinderTest < Minitest::Test

include Finder

attr_reader :se

  def setup
    @se = SalesEngine.from_csv({:items => './data/test_items.csv',
                                :merchants => './data/test_merchant.csv',
                                :invoices => './data/test_invoices.csv',
                                :invoice_items => './data/test_invoice_items.csv',
                                :transactions => './data/test_transactions.csv',
                                :customers => './data/test_customers.csv'})
  end

  def test_finder_module_exists
    assert_equal Module, Finder.class
  end

  def test_find_by_id_returns_an_instance_of_merchant
    merchant = se.merchants.find_by_id(1)
    assert merchant.instance_of?(Merchant)
  end

  def test_find_by_id_returns_an_instance_of_item
    item = se.items.find_by_id(263519844)
    assert item.instance_of?(Item)
  end

end
