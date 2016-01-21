require 'minitest'
require 'minitest/pride'
require_relative '../lib/merchant'

class MerchantTest < Minitest::Test
attr_reader :merchant

  def setup
    @merchant = Merchant.new({:name => "test name", :id => 3,
                              :created_at => "2012-03-27 14:53:59 UTC",
                              :updated_at => "2012-03-27 14:53:59 UTC"})
  end

  def test_merchant_can_be_initialized
    assert_equal Merchant, merchant.class
  end

  def test_merchant_can_generate_an_id
    assert_equal 3, merchant.id
  end

  def test_merchant_can_pull_a_name
    assert_equal "test name", merchant.name
  end

  def test_merchant_can_pull_updated_at
    assert_equal "2012-03-27 14:53:59 UTC", merchant.updated_at.to_s
  end

  def test_merchant_can_pull_created_at
    assert_equal "2012-03-27 14:53:59 UTC", merchant.created_at.to_s
  end
end
