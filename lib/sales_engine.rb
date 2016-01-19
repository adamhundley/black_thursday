require_relative "item_repository"
require_relative "merchant_repository"
require_relative "invoice_repository"
require_relative "invoice_item_repository"
require_relative "transaction_repository"
require_relative "customer_repository"

class SalesEngine
attr_reader :items, :merchants, :invoices, :invoice_items, :transactions, :customers

  def self.from_csv(files)
    SalesEngine.new(files)
  end

  def initialize(files)
    load_files(files)
    relationships
  end

  def load_files(files)
    @merchants ||= MerchantRepository.new(files[:merchants])
    @items ||= ItemRepository.new(files[:items])
    @invoices ||= InvoiceRepository.new(files[:invoices])
    @invoice_items ||= InvoiceItemRepository.new(files[:invoice_items])
    @transactions ||= TransactionRepository.new(files[:transactions])
    @customers ||= CustomerRepository.new(files[:customers])
  end

  def relationships
    invoice_to_merchant_relationship
    invoice_to_items_relationship
    invoice_to_transactions_relationship
    invoice_to_customer_relationship
    invoice_to_invoice_items_relationship
    merchant_to_item_relationship
    merchant_to_invoice_relationship
    merchant_to_customers_relationship
    customer_to_merchants_relationship
    item_to_merchant_relationship
    transaction_to_invoice_relationship
  end

  def invoice_to_merchant_relationship
    invoices.all.each { |invoice| invoice.merchant = merchants.find_by_id(invoice.merchant_id) }
  end

  def invoice_to_items_relationship
    invoices.all.each { |invoice|
      invoices_items = invoice_items.find_all_by_invoice_id(invoice.id)
      item_ids = invoices_items.map { |invoice_item| invoice_item.item_id }
      invoice.items = item_ids.map { |item_id| items.find_by_id(item_id) } }
  end

  def invoice_to_transactions_relationship
    invoices.all.each { |invoice| invoice.transactions = transactions.find_all_by_invoice_id(invoice.id) }
  end

  def invoice_to_customer_relationship
    invoices.all.each { |invoice| invoice.customer = customers.find_by_id(invoice.customer_id) }
  end

  def invoice_to_invoice_items_relationship
    invoices.all.each { |invoice| invoice.invoice_items = invoice_items.find_all_by_invoice_id(invoice.id) }
  end

  def transaction_to_invoice_relationship
    transactions.all.each { |transaction| transaction.invoice = invoices.find_by_id(transaction.invoice_id) }
  end

  def merchant_to_customers_relationship
    merchants.all.each { |merchant|
      merchant_invoices = invoices.find_all_by_merchant_id(merchant.id)
      customer_ids = merchant_invoices.map { |invoice| invoice.customer_id }.uniq
      merchant.customers = customer_ids.map { |id| customers.find_by_id(id) } }
  end

  def customer_to_merchants_relationship
    customers.all.each { |customer|
      customer_invoices = invoices.find_all_by_customer_id(customer.id)
      merchant_ids = customer_invoices.map { |invoice| invoice.merchant_id }
      customer.merchants = merchant_ids.map { |id| merchants.find_by_id(id) } }
  end

  def merchant_to_invoice_relationship
    merchants.all.each { |merchant| merchant.invoices = invoices.find_all_by_merchant_id(merchant.id) }
  end

  def merchant_to_item_relationship
    merchants.all.each { |merchant| merchant.items = items.find_all_by_merchant_id(merchant.id) }
  end

  def item_to_merchant_relationship
    items.all.each { |item| item.merchant = merchants.find_by_id(item.merchant_id) }
  end
end
