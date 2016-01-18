require 'minitest'
require 'minitest/pride'
require './lib/transaction'

class TransactionTest < Minitest::Test
attr_reader :transaction
  def setup
    @transaction = Transaction.new({:id => 1, :invoice_id => 23453, :created_at => "2012-03-27 14:53:59 UTC", :updated_at => "2012-03-27 14:53:59 UTC", :credit_card_number => "1234567812345678", :credit_card_expiration_date => "0220", :result => "success"})
  end

  def test_transaction_can_be_initialized
    assert_equal Transaction, transaction.class
  end
  
  def test_transaction_can_generate_an_id
    assert_equal 1, transaction.id
  end

  def test_transaction_can_pull_updated_at
    expected = Time.parse("2012-03-27 14:53:59 UTC")
    assert_equal expected, transaction.updated_at
  end

  def test_transaction_can_pull_created_at
    expected = Time.parse("2012-03-27 14:53:59 UTC")
    assert_equal expected , transaction.created_at
  end

  def test_transaction_can_pull_invoice_id
    assert_equal 23453, transaction.invoice_id
  end

  def test_transaction_can_pull_credit_card_number
    assert_equal 1234567812345678, transaction.credit_card_number
  end

  def test_transaction_can_pull_credit_card_expiration_date
    assert_equal "0220", transaction.credit_card_expiration_date
  end

  def test_transaction_can_pull_result
    assert_equal "success", transaction.result
  end
end
