def range(start,finish)

  if start == finish
    return [start]
  else
    return [start] + range(start+1,finish)
  end

end



def recursive_sum(arr)
  if arr.count == 1
    return arr[0] 
  else
    return arr[0] + recursive_sum(arr[1..-1])
  end
end


def iterative_sum(arr)
  sum = 0
  arr.each do |elem| 
    sum = sum + elem
  end
  sum
end

def exponent1(num,pow)
  if pow == 0
    return 1
  else
    return num * exponent1(num,pow-1)
  end
end

def exponent2(num,pow)
  if pow == 0
    return 1 
  else
    if (pow % 2) == 0 
      exponent2(num,pow/2) ** 2
    else
      num * exponent2(num,(pow-1)/2) ** 2
    end
  end
end



def deep_dup(arr)
  result = []
  if !arr.is_a?(Array)
    return arr
  else
    arr.each do |elem|
      result << deep_dup2(elem)
    end
  end

  result
end

def recur_fib(n)
  if n == 1
    return [0]
  elsif n == 2
    return [0, 1]
  else
    previous = recur_fib(n - 1)
    return  previous + [previous[-1] + previous[-2]]
  end
end

def fib_i(int)
  new_array = [0, 1]
  (int - 2).times { |index| new_array << new_array[-1] + new_array[-2] }

  new_array
end

def bsearch(array, target)
  mid_position = array.length / 2
  comparinator = array[mid_position] <=> target
  return nil if array.length == 0

  # Recursion!!
  case comparinator
  when -1
    # when midpoint less than target
    sub_array = array[(mid_position + 1)..-1]
    sub_search_index = bsearch(sub_array, target)

    if (sub_search_index.nil?)
      return nil 
    else 
      return mid_position + 1 + sub_search_index
    end
    
  when 1
    # when midpoint greater than target
    sub_array = array[0..(mid_position - 1)]
    sub_search_index = bsearch(sub_array, target)
  when 0
    mid_position
  end
end

def make_change(amount, coins = [25, 10, 5, 1])
  change = []

  # Base Case
  large_coins = coins.reject {|coin| coin == 1}
  large_coins.each do |coin|
    if amount % coin == 0
      how_many = amount / coin
      change = Array.new(how_many, coin)
      return change
    end
  end

  # Recursive Step
  coins.each do |coin|
    if (amount - coin) < 0
      next
    else
      change << coin
      change += make_change(amount - coin)
      break
    end
  end
  
  change
end

def merge_sort(array)
  return array if array.length <= 1

  # Recursive
  middle      = array.length / 2
  left, right = array[0...middle], array[middle..-1]
  left        = merge_sort(left)
  right       = merge_sort(right)

  return merge(left, right)
end

def merge(left, right)
  result = []

  p left, right

  while left.length > 0 || right.length > 0

    if left.length > 0 and right.length > 0

      if left.first <= right.first
        result << left.shift
      else
        result << right.shift
      end

    elsif  left.length > 0
      result << left.shift

    elsif right.length > 0
      result << right.shift
    end
  end

  result
end

