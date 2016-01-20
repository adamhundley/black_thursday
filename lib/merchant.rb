
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
    Time.parse(merchant[:created_at])
  end

  def updated_at
    Time.parse(merchant[:updated_at])
  end

  def revenue
    invoices.map  do |invoice|
      invoice.total if invoice.is_paid_in_full?
    end.compact.inject(0, :+)
  end

end
