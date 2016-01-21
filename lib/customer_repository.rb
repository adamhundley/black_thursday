require 'customer'
require 'csv_loader'
require 'finder'

class CustomerRepository
include CsvLoader
include Finder
attr_reader :all

  def initialize(customer_file)
    data_into_hash(load_data(customer_file))
  end

  def data_into_hash(data)
    @all ||= data.map do |row|
      id = row[:id].to_i
      first_name = row[:first_name]
      last_name = row[:last_name]
      created_at = row[:created_at]
      updated_at = row[:updated_at]

      hash = {:id => id,
              :first_name => first_name, :last_name => last_name,
              :created_at => created_at, :updated_at => updated_at}
      Customer.new(hash)
    end
  end

  def find_all_by_first_name(first_name)
    all.find_all { |x| x.first_name.downcase.include?(first_name.downcase) }
  end

  def find_all_by_last_name(last_name)
    all.find_all { |x| x.last_name.downcase.include?(last_name.downcase) }
  end

end
