class Array
  def my_each(&block)
    index = 0
    while index < self.length
      yield self[index]
      index += 1
    end

    self
  end

  def my_map(&block)
    empty_array = []

    self.my_each do |item|
      empty_array << block.call(item)
    end

    empty_array
  end

  def my_select(&block)
    new_array = []

    self.my_each do |item|
      new_array << item if yield(item)
    end

    new_array
  end

  def my_inject(&block)
    
    accum = self[0]
    index = 1

    while index < self.length
      accum = yield [accum, self[index]]
    end

    accum
  end

  def my_sort!(&block)
    swapped = true

    until swapped == false
      swapped = false

      self.count.times do |index|
        next if (index + 1 ) == self.count

        compare = yield [self[index], self[index + 1]]

        if compare == 1
          self[index], self[index + 1] = self[index + 1], self[index]
          swapped = true
        end
      end
    end

    self
  end
end

def splattr (*arguments, &block)

  if !block
    puts "GIMME MY BLOCK!!!!"
    return
  end

  yield *arguments

end


# p [1,3,5].my_sort! { |num1, num2| num2 <=> num1 }
