def set_add_el(set, el)
  set[el] = true

  set
end

def set_remove_el(set, el)
  set.delete(el)

  set
end

def set_list_els(set)
  set.keys
end

def set_member?(set, el)
  set.has_key?(el)
end

def set_union(set1, set2)
  # I had this one create a new set rather than modify either.
  set1.merge(set2)
end

def set_intersection(set1, set2)
  # Use `dup` to avoid modifying set1.
  # Use _ for unused block parameters.
  set1.dup.keep_if { |key, _| set2.has_key?(key) }
end

def set_minus(set1, set2)
  set1.dup.delete_if { |key| set2.has_key?(key) }
end
