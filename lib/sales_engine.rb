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
    @merchants = MerchantRepository.new(files[:merchants])
    @items = ItemRepository.new(files[:items])
    @invoices = InvoiceRepository.new(files[:invoices])
    @invoice_items = InvoiceItemRepository.new(files[:invoice_items])
    @transactions = TransactionRepository.new(files[:transactions])
    @customers = CustomerRepository.new(files[:customers])
  end

  def relationships
    merchant_to_item_relationship
    merchant_to_invoice_relationship
    merchant_to_customers_relationship
    customer_to_merchants_relationship
    item_to_merchant_relationship
    transaction_to_invoice_relationship
    invoice_to_merchant_relationship
    invoice_to_items_relationship
    invoice_to_transactions_relationship
    invoice_to_customer_relationship
  end

  def invoice_to_merchant_relationship
    invoices.all.each do |invoice|
      invoice.merchant = merchants.find_by_id(invoice.merchant_id)
    end
  end
  #
  def invoice_to_items_relationship
    # invoices.all.each do |invoice|
    #   invoices_items = invoice_items.find_all_by_invoice_id(invoice.id)
    #   item_ids = invoices_items.map { |invoice_item| invoice_item.item_id}
    #   invoice.items = item_ids.map { |item_id| items.find_by_id(item_id) }
    # end
  end

  def invoice_to_transactions_relationship

  end

  def invoice_to_customer_relationship

  end

  def transaction_to_invoice_relationship

  end

  def merchant_to_customers_relationship

  end

  def customer_to_merchants_relationship

  end


  def merchant_to_invoice_relationship
    merchants.all.each do |merchant|
      merchant.invoices = invoices.find_all_by_merchant_id(merchant.id)
    end
  end

  def merchant_to_item_relationship
    merchants.all.each do |merchant|
      merchant.items = items.find_all_by_merchant_id(merchant.id)
    end
  end

  def item_to_merchant_relationship
    items.all.each do |item|
      item.merchant = merchants.find_by_id(item.merchant_id)
    end
  end



end
