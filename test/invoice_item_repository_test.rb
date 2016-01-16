require 'minitest/autorun'
require 'minitest/pride'
require './lib/invoice_item_repository'

class InvoiceItemRepositoryTest < Minitest::Test
attr_reader :invoice_item_repo

  def setup
    invoice_file = './data/test_invoice_items.csv'
    @invoice_item_repo = InvoiceItemRepository.new(invoice_file)
  end

  def test_an_instance_of_invoice_repo_exists
    assert invoice_item_repo.instance_of?(InvoiceItemRepository)
  end

  def test_invoice_item_repo_can_load_data
    assert_equal 20, invoice_item_repo.all.count
  end

  def test_invoice_item_repo_all_method_always_returns_instance_of_invoice
    expected = invoice_item_repo.all
    expected.each do |invoice|
      assert_equal InvoiceItem, invoice.class
    end
  end

  def test_find_by_id_defaults_nil
    assert_equal nil, invoice_item_repo.find_by_id(56)
  end

  def test_find_by_id_works
    assert invoice_item_repo.find_by_id(1)
  end

  def test_find_all_by_item_id_defaults_to_empty_array
    assert_equal [], invoice_item_repo.find_all_by_item_id(99)
  end

  def test_find_all_by_item_id_returns_matching_invoice_items
    assert_equal 1, invoice_item_repo.find_all_by_item_id(263454779).count
  end

  def test_find_all_by_invoice_id_returns_an_empty_array
    assert_equal [], invoice_item_repo.find_all_by_invoice_id(65)
  end

  def test_find_all_by_invoice_id_returns_matching_invoice_items
    assert_equal 8, invoice_item_repo.find_all_by_invoice_id(1).count
  end
  
end
