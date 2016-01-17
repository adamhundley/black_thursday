class Customer
  attr_reader :customer
  attr_accessor :merchants

  def initialize(customer)
    @customer = customer
  end

  def id
    customer[:id].to_i
  end

  def first_name
    customer[:first_name]
  end

  def last_name
    customer[:last_name]
  end

  def created_at
    Time.parse(customer[:created_at])
  end

  def updated_at
    Time.parse(customer[:updated_at])
  end
end
