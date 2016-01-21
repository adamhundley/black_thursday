module InvoiceAnalysis

  def paid_in_full_invoices(merchant)
    merchant.invoices.select { |invoice| invoice.is_paid_in_full? }
  end

  def total_invoices
    invoices.all.count.to_f
  end

  def invoice_status(status)
    ((total_invoices_with_common_status(status)/total_invoices) * 100).round(2)
  end

  def day_of_invoice
    invoices.all.map { |invoice| invoice.created_at.strftime("%A") }
  end

  def group_invoices_by_day
    day_of_invoice.group_by { |day| day }
  end

  def count_invoices_by_day
    group_invoices_by_day.map { |k, v| [k, v.count] }.to_h
  end

  def average_invoices_per_day
    average_calculator(total_invoices, 7)
  end

  def variance_of_invoices_per_day_from_average_squared
    avg = average_invoices_per_day
    count_invoices_by_day.values.map { |v| (v - avg) ** 2 }.inject(:+).round(2)
  end

  def variance_divided_by_total_invoices
    variance = variance_of_invoices_per_day_from_average_squared
    total = 7
    vars_of_avg_div_by_total(variance, total)
  end

  def sd_of_invoices_per_day
    standard_deviation(variance_divided_by_total_invoices)
  end

  def top_days_by_invoice_count
    sd = sd_of_invoices_per_day
    avg = average_invoices_per_day
    count_invoices_by_day.map { |day , val| day if val > (avg + sd) }.compact
  end

end
