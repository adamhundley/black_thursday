require 'minitest'
require 'minitest/pride'
require './lib/invoice_item'

class InvoiceItemTest < Minitest::Test
attr_reader :invoice_item
  def setup
    @invoice_item = InvoiceItem.new({:id => 1, :item_id => 435, :invoice_id => 23453, :created_at => "2012-03-27 14:53:59 UTC", :updated_at => "2012-03-27 14:53:59 UTC", :quantity => 12, :unit_price => 342})
  end

  def test_invoice_item_can_be_initialized
    assert_equal InvoiceItem, invoice_item.class
  end

  def test_invoice_item_can_generate_an_id
    assert_equal 1, invoice_item.id
  end

  def test_invoice_item_can_pull_updated_at
    expected = Time.parse("2012-03-27 14:53:59 UTC")
    assert_equal expected, invoice_item.updated_at
  end

  def test_invoice_item_can_pull_created_at
    expected = Time.parse("2012-03-27 14:53:59 UTC")
    assert_equal expected , invoice_item.created_at
  end

  def test_invoice_item_can_pull_item_id
    assert_equal 435, invoice_item.item_id
  end

  def test_invoice_item_can_pull_invoice_id
    assert_equal 23453, invoice_item.invoice_id
  end

  def test_invoice_item_can_pull_quantity
    assert_equal 12, invoice_item.quantity
  end

  def test_invoice_item_can_pull_unit_price
    assert_equal 342, invoice_item.unit_price
  end

  def test_unit_price_to_dollars_returns_dollars_formated_as_float
    assert_equal 342, invoice_item.unit_price_to_dollars
    assert_equal Float, invoice_item.unit_price_to_dollars.class
  end
end
