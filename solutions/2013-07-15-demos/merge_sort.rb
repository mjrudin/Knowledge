def merge_sort(array)
  if array.count < 2
    return array
  end

  half_count = array.count / 2

  sorted_left = merge_sort(array.take(half_count))
  sorted_right = merge_sort(array.drop(half_count))

  merge(sorted_left, sorted_right)
end

def merge(sorted_left, sorted_right)
  merged_array = []

  until (sorted_left.empty? || sorted_right.empty?)
    if sorted_left.first < sorted_right.first
      merged_array << sorted_left.shift
    else
      merged_array << sorted_right.shift
    end
  end

  merged_array + sorted_left + sorted_right
end

def subsets(array)
  if array.empty?
    return [[]]
  end

  el = array[0]
  old_subsets = subsets(array.drop(1))
  new_subsets = old_subsets.map { |old_subset| old_subset + [el] }

  new_subsets + old_subsets
end
