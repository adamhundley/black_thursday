require 'bigdecimal'
require 'invoice_item'
require 'csv_loader'
require 'finder'

class InvoiceItemRepository
include CsvLoader
include Finder
attr_reader :all

  def inspect
    "#<#{self.class} #{@all.size} rows>"
  end

  def initialize(invoice_item_file)
    data_into_hash(load_data(invoice_item_file))
  end

  def data_into_hash(data)
    @all ||= data.map do |row|
      id = row[:id]
      item_id = row[:item_id].to_i
      created_at = row[:created_at]
      updated_at = row[:updated_at]
      invoice_id = row[:invoice_id].to_i
      quantity = row[:quantity]
      unit_price = convert_to_big_decimal(row[:unit_price])

      hash = {:id => id,
              :item_id => item_id, :invoice_id => invoice_id,
              :quantity => quantity,
              :created_at => created_at, :updated_at => updated_at, :unit_price => unit_price}
      InvoiceItem.new(hash)
    end
  end

  def find_all_by_item_id(item_id)
    all.find_all { |x| x.item_id == item_id }
  end

end
