class FinanceProcessor
  def self.process(user)
    return unless user.last_processed_date

    current_date = Date.current
    return if user.last_processed_date >= current_date

    # To calculate safely, we process day by day
    # Or for efficiency we can just calculate what happened between last_processed_date + 1 and current_date
    # Since missed days could be many, but usually just 1, iterating day by day is safe and handles leap years, etc.

    (user.last_processed_date + 1.day).upto(current_date) do |date|
      balance_change = 0

      # 1. Income
      if user.income_day.present? && user.income.present?
        if date.day == user.income_day
          balance_change += user.income
        elsif date.day == date.end_of_month.day && user.income_day > date.day
          # If income day is 31 and month has 30 days, we apply it on the 30th
          balance_change += user.income
        end
      end

      # 2. Subscriptions
      user.subscriptions.find_each do |sub|
        if sub.frequency == "monthly"
          if date.day == sub.billing_day
            balance_change -= (sub.price * sub.quantity)
          elsif date.day == date.end_of_month.day && sub.billing_day > date.day
            # Apply on last day of month if billing day is past end of month
            balance_change -= (sub.price * sub.quantity)
          end
        elsif sub.frequency == "weekly"
          # Weekly matches the day of the week
          if date.wday == sub.start_date.wday
            balance_change -= (sub.price * sub.quantity)
          end
        end
      end

      user.update!(balance: user.balance + balance_change) if balance_change != 0
    end

    user.update!(last_processed_date: current_date)
  end
end
