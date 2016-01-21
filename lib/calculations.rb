module Calculations

  def average_calculator(numerator, denominator)
    (numerator/denominator).round(2)
  end

  def vars_of_avg_div_by_total(variance, total)
    (variance/(total - 1)).round(2)
  end

  def standard_deviation(final_variance_calculation)
    Math.sqrt(final_variance_calculation).round(2)
  end

end
