def my_uniq(array)
  uniq_array = []

  array.each do |el|
    uniq_array << el unless uniq_array.include?(el)
  end

  uniq_array
end

# Alternatively with inject:
#
# def my_uniq(array)
#   array.inject([]) do |uniq_array, el|
#     uniq_array << el unless uniq_array.include?(el)
#     uniq_array
#   end
# end

def two_sum(array)
  pairs = []

  array.count.times do |i1|
    (i1 + 1).upto(array.count - 1) do |i2|
      pairs << [i1, i2] if array[i1] + array[i2] == 0
    end
  end

  pairs
end

def pick_stocks(prices)
  best_pair = nil
  best_profit = 0

  prices.count.times do |buy_date|
    prices.count.times do |sell_date|
      # can't sell before buy
      next if sell_date < buy_date

      profit = prices[sell_date] - prices[buy_date]
      if profit > best_profit
        best_pair, best_profit = [buy_date, sell_date], profit
      end
    end
  end

  best_pair
end

def transpose(rows)
  cols = Array.new(rows.first.count) { [] }
  rows.each do |row|
    row.count.times do |j|
      cols[j] << row[j]
    end
  end

  cols
end
