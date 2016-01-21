module MerchantAnalysis
  def total_merchants
    merchants.all.count.to_f
  end

  def earning_merchants
    merchants.all.reject { |merch| merch.revenue == nil || merch.revenue == 0 }
  end

  def merchants_ranked_by_revenue
    earning_merchants.sort_by { |merchant| merchant.revenue}.reverse
  end

  def top_revenue_earners(num = 20)
    merchants_ranked_by_revenue[0..(num-1)]
  end

  def find_merchant(merchant_id)
    merchants.find_by_id(merchant_id)
  end

  def merchants_with_only_one_item
    merchants.all.map { |merch| merch if merch.items.count == 1 }.compact
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.map do |merch|
      merch if merch.created_at.strftime("%B") == month
    end.compact
  end

  def revenue_by_merchant(merchant_id)
    find_merchant(merchant_id).revenue
  end

end
