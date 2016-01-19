
class Merchant
  attr_reader :merchant
  attr_accessor :items, :invoices, :customers

  def inspect
    "#<#{self.class}>"
  end

  def initialize(merchant)
    @merchant = merchant
  end

  def name
    merchant[:name]
  end

  def id
    merchant[:id].to_i
  end

  def created_at
    merchant[:created_at]
  end

  def updated_at
    merchant[:updated_at]
  end

  def total
    invoices.map { |invoice| invoice.total }.compact.inject(:+)
  end

end
