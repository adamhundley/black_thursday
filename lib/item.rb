require 'bigdecimal'

class Item
  attr_reader :item
  attr_accessor :merchant

  def inspect
    "#<#{self.class}>"
  end

  def initialize(item)
    @item = item
  end

  def name
    item[:name]
  end

  def id
    item[:id].to_i
  end

  def merchant_id
    item[:merchant_id].to_i
  end

  def created_at
    Time.parse(item[:created_at])
  end

  def updated_at
    Time.parse(item[:updated_at])
  end

  def description
    item[:description]
  end

  def unit_price
    item[:unit_price]
  end

  def unit_price_to_dollars
    (unit_price / 100).round(2)
  end

end
