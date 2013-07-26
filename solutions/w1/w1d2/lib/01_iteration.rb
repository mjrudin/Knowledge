def loop_through_nums
  i = 0
  i += 1 until (i > 250) && (i % 7 == 0)
  i
end

def factors(num)
  (1..num).select { |i| num % i == 0 }
end

def all_factors(num)
  all_factors = {}
  (1..num).each { |i| all_factors[i] = factors(i) }
  all_factors
end

def print_all_factors
  all_factors(100).each do |num, factors|
    puts "#{num}: #{factors.inspect}"
  end
end

class Array
  def bubble_sort
    self.dup.bubble_sort!
  end

  def bubble_sort!
    sorted = false
    until sorted
      sorted = true
      self.count.times do |index|
        # last element has no next element
        next if (index + 1) == self.count

        if self[index] > self[index + 1]
          self[index], self[index + 1] = self[index + 1], self[index]
          sorted = false
        end
      end
    end

    self
  end
end

def substrings(string)
  subs = []

  string.length.times do |sub_start|
    ((sub_start + 1)..(string.length)).each do |sub_end|
      subs << string[sub_start...sub_end]
    end
  end

  #prune substrings of duplicates
  subs.uniq
end

def subwords(word, dictionary_filename)
  dictionary_words = File.readlines(dictionary_filename).map(&:chomp)

  substrings(word).select { |substring| dictionary_words.include?(substring) }
end

require 'set'
def faster_subwords(word, dictionary_filename)
  # compare for length 100 word
  dictionary_words_array = File.readlines(dictionary_filename).map(&:chomp)

  # this will turn the array into a `Set` object; `Set#include?` is
  # much faster.
  dictionary_words_set = Set.new(dictionary_words_array)

  substrings(word).select { |substring| dictionary_words_set.include?(substring) }
end
