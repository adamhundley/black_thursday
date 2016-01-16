require 'minitest/autorun'
require 'minitest/pride'
require './lib/transaction_repository'

class TransactionRepositoryTest < Minitest::Test
attr_reader :transaction_repo

  def setup
    invoice_file = './data/test_transactions.csv'
    @transaction_repo = TransactionRepository.new(invoice_file)
  end

  def test_an_instance_of_transaction_repo_exists
    assert transaction_repo.instance_of?(TransactionRepository)
  end

  def test_transaction_repo_can_load_data
    assert_equal 20, transaction_repo.all.count
  end

  def test_transaction_repo_all_method_always_returns_instance_of_invoice
    expected = transaction_repo.all
    expected.each do |invoice|
      assert_equal Transaction, invoice.class
    end
  end

  def test_find_by_id_defaults_nil
    assert_equal nil, transaction_repo.find_by_id(56)
  end

  def test_find_by_id_works
    assert transaction_repo.find_by_id(1)
  end

  def test_find_all_by_invoice_id_defaults_to_empty_array
    assert_equal [], transaction_repo.find_all_by_invoice_id(99)
  end

  def test_find_all_by_invoice_id_returns_matching_invoice_items
    assert_equal 1, transaction_repo.find_all_by_invoice_id(4966).count
  end

  def test_find_all_by_credit_card_number_returns_an_empty_array
    assert_equal [], transaction_repo.find_all_by_credit_card_number(1111111111111111)
  end

  def test_find_all_by_credit_card_number_returns_matching_invoice_items
    assert_equal 1, transaction_repo.find_all_by_credit_card_number(4318767847968505).count
  end

  def test_find_all_by_result_returns_an_empty_array
    assert_equal [], transaction_repo.find_all_by_result("dumpy")
  end

  def test_find_all_by_result_invoice_items
    assert_equal 17, transaction_repo.find_all_by_result("success").count
    assert_equal 3, transaction_repo.find_all_by_result("failed").count
  end
end
