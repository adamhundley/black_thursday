class Invoice
  attr_reader :invoice
  attr_accessor :merchant, :items, :transactions, :customer

  def initialize(invoice)
    @invoice = invoice
  end

  def customer_id
    invoice[:customer_id].to_i
  end

  def id
    invoice[:id].to_i
  end

  def merchant_id
    invoice[:merchant_id].to_i
  end

  def created_at
    Time.parse(invoice[:created_at])
  end

  def updated_at
    Time.parse(invoice[:updated_at])
  end

  def status
    invoice[:status].to_sym
  end

  def is_paid_in_full?
    transactions.any? { |transaction| transaction.result == "success" }
  end
end
