require 'minitest'
require 'minitest/pride'
require './lib/customer'

class CustomerTest < Minitest::Test
attr_reader :customer
  def setup
    @customer = Customer.new({:id => 1, :created_at => "2012-03-27 14:53:59 UTC", :updated_at => "2012-03-27 14:53:59 UTC", :first_name => "Bob", :last_name => "Jones"})
  end

  def test_customer_can_be_initialized
    assert_equal Customer, customer.class
  end

  def test_customer_can_generate_an_id
    assert_equal 1, customer.id
  end

  def test_customer_can_pull_updated_at
    expected = Time.parse("2012-03-27 14:53:59 UTC")
    assert_equal expected, customer.updated_at
  end

  def test_customer_can_pull_created_at
    expected = Time.parse("2012-03-27 14:53:59 UTC")
    assert_equal expected , customer.created_at
  end

  def test_customer_can_pull_first_name
    assert_equal "Bob", customer.first_name
  end

  def test_customer_can_pull_last_name
    assert_equal "Jones", customer.last_name
  end
end
