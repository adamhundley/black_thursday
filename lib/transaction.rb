class Transaction
  attr_reader :transaction
  attr_accessor :invoice

  def inspect
    "#<#{self.class}>"
  end

  def initialize(transaction)
    @transaction = transaction
  end

  def id
    transaction[:id].to_i
  end

  def invoice_id
    transaction[:invoice_id].to_i
  end

  def created_at
    Time.parse(transaction[:created_at])
  end

  def updated_at
    Time.parse(transaction[:updated_at])
  end

  def credit_card_number
    transaction[:credit_card_number].to_i
  end

  def credit_card_expiration_date
    transaction[:credit_card_expiration_date]
  end

  def result
    transaction[:result]
  end
end
