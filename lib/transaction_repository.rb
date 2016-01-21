require 'transaction'
require 'csv_loader'
require 'finder'

class TransactionRepository
include CsvLoader
include Finder
attr_reader :all

  def initialize(transaction_file)
    data_into_hash(load_data(transaction_file))
  end

  def data_into_hash(data)
    @all ||= data.map do |row|
      id = row[:id].to_i
      invoice_id = row[:invoice_id]
      created_at = row[:created_at]
      updated_at = row[:updated_at]
      result = row[:result]
      credit_card_number = row[:credit_card_number]
      credit_card_expiration_date = row[:credit_card_expiration_date]

      hash = {:id => id,
              :result => result, :invoice_id => invoice_id,
              :credit_card_number => credit_card_number,
              :created_at => created_at,
              :updated_at => updated_at,
              :credit_card_expiration_date => credit_card_expiration_date}
      Transaction.new(hash)
    end
  end

  def find_all_by_item_id(item_id)
    all.find_all { |x| x.item_id == item_id }
  end

  def find_all_by_credit_card_number(credit_card_number)
    all.find_all { |x| x.credit_card_number == credit_card_number }
  end

  def find_all_by_result(result)
    all.find_all { |x| x.result == result }
  end
end
