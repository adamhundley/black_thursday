require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine'

class SalesEngineTest < Minitest::Test
attr_reader :se_hash, :se

  def setup
    @se_hash = {:items => './data/test_items.csv',
            :merchants => './data/test_merchant.csv',
            :invoices => './data/test_invoices.csv',
            :invoice_items => './data/test_invoice_items.csv',
            :transactions => './data/test_transactions.csv',
            :customers => './data/test_customers.csv'}

    @se = SalesEngine.from_csv(se_hash)
  end

  def test_an_instance_of_sales_engine_exists
    se = SalesEngine.new(se_hash)

    assert se.instance_of?(SalesEngine)
  end

  def test_items_instantiates_items_repo
    item = se.items

    assert item.instance_of?(ItemRepository)
  end

  def test_merchants_instantiates_merchants_repo
    merchants = se.merchants

    assert merchants.instance_of?(MerchantRepository)
  end

  def test_invoices_instantiates_invoice_repo
    invoices = se.invoices

    assert invoices.instance_of?(InvoiceRepository)
  end

  def test_invoice_items_instantiates_invoice_items_repo
    invoice_items = se.invoice_items

    assert invoice_items.instance_of?(InvoiceItemRepository)
  end

  def test_transactions_instantiates_transactions_repo
    transactions = se.transactions

    assert transactions.instance_of?(TransactionRepository)
  end

  def test_customers_instantiates_customers_repo
    customers = se.customers

    assert customers.instance_of?(CustomerRepository)
  end

  def test_items_contains_instances_of_items
    item = se.items.all[0]

    assert item.instance_of?(Item)
  end

  def test_merchants_contains_instances_of_merchants
    merchants = se.merchants.all[0]

    assert merchants.instance_of?(Merchant)
  end

  def test_invoices_contains_instances_of_invoices
    invoices = se.invoices.all[0]

    assert invoices.instance_of?(Invoice)
  end

  def test_invoice_items_contains_instances_of_invoice_items
    invoice_items = se.invoice_items.all[0]

    assert invoice_items.instance_of?(InvoiceItem)
  end

  def test_transactions_contains_instances_of_transactions
    transactions = se.transactions.all[0]

    assert transactions.instance_of?(Transaction)
  end

  def test_customers_contains_instances_of_customers
    customers = se.customers.all[0]

    assert customers.instance_of?(Customer)
  end

  def test_items_returns_all
    item = se.items
    assert_equal 5, item.all.count
  end

  def test_merchants_returns_merchant_repo_instance
    merchants = se.merchants
    assert_equal 5, merchants.all.count
  end

  def test_sales_engine_can_find_by_id
    merchants = se.merchants
    found = merchants.find_by_id(1)
    assert_equal "Schroeder-Jerde", found.name
  end

  def test_invoice_to_merchants_relationship
    invoices = se.invoices.all
    invoice_merchant = invoices[1].merchant
    assert_equal Merchant, invoice_merchant.class
  end

  def test_merchant_to_invoice_relationship
    merchants = se.merchants.all
    merchants_invoice = merchants[0].invoices[0]
    assert_equal Invoice, merchants_invoice.class
  end

  def test_merchant_to_item_relationship
    merchants = se.merchants.all
    merchants_items = merchants[0].items[0]
    assert_equal Item, merchants_items.class
  end

  def test_item_to_merchant_relationship
    items = se.items.all
    items_merchant = items[0].merchant
    assert_equal Merchant, items_merchant.class
  end

  def test_items_can_be_accessed_by_merchant
    merchant = se.items
    items = merchant.find_all_by_merchant_id(1)
    assert_equal 2, items.count
  end

  def test_merchant_with_no_items_returns_empty_array
    merchant = se.items
    items = merchant.find_all_by_merchant_id(6)
    assert_equal [], items
  end

  def test_invoice_to_items_relationship
    invoice = se.invoices.find_by_id(1)
    assert_equal Item, invoice.items[0].class
  end

  def test_invoice_to_transactions_relationship
    invoice = se.invoices.find_by_id(1)
    assert_equal Transaction, invoice.transactions[0].class
    assert_equal 1, invoice.transactions.length
  end

  def test_invoice_to_customer_relationship
    invoice = se.invoices.find_by_id(2)
    assert_equal Customer, invoice.customer.class
  end


  def test_transaction_to_invoice_relationship
    transaction = se.transactions.find_by_id(3)
    assert_equal Invoice, transaction.invoice.class
  end

  def test_merchant_to_customers_realtionship
    merchant = se.merchants.find_by_id(1)
    assert_equal Customer, merchant.customers[1].class
  end

  def test_cutsomer_to_merchants_relationship
    customer = se.customers.find_by_id(1)
    assert_equal Merchant, customer.merchants[1].class
  end


end
