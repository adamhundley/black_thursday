require 'minitest/autorun'
require 'minitest/pride'
require './lib/customer_repository'

class CustomerRepositoryTest < Minitest::Test
attr_reader :customer_repo

  def setup
    invoice_file = './data/test_customers.csv'
    @customer_repo = CustomerRepository.new(invoice_file)
  end

  def test_an_instance_of_customer_repo_exists
    assert customer_repo.instance_of?(CustomerRepository)
  end

  def test_customer_repo_can_load_data
    assert_equal 20, customer_repo.all.count
  end

  def test_customer_repo_all_method_always_returns_instance_of_invoice
    expected = customer_repo.all
    expected.each do |customer|
      assert_equal Customer, customer.class
    end
  end

  def test_find_by_id_defaults_nil
    assert_equal nil, customer_repo.find_by_id(56)
  end

  def test_find_by_id_works
    assert customer_repo.find_by_id(1)
  end

  def test_find_all_by_first_name_defaults_to_empty_array
    assert_equal [], customer_repo.find_all_by_first_name("Jared")
  end

  def test_find_all_by_first_name_returns_matching_invoice_items
    assert_equal 1, customer_repo.find_all_by_first_name("Joey").count
  end

  def test_find_all_by_last_name_returns_an_empty_array
    assert_equal [], customer_repo.find_all_by_last_name("Jhoana")
  end

  def test_find_all_by_last_name_returns_matching_invoice_items
    assert_equal 1, customer_repo.find_all_by_last_name("Toy").count
  end


end
