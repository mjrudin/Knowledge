require '00_array'

# Array has a `uniq` method that removes duplicates from an array. It
# returns the unique elements in the order in which they first appeared:
#
# ```ruby
# [1, 2, 1, 3, 3].uniq # => [1, 2, 3]
# ```
#
# Write your own `uniq` method, called `my_uniq`; it should take in an
# Array and return a new array. It should not call `uniq`.
#
# One special feature of Ruby classes is that they are *open*; we can
# add new methods to existing classes. Here, add your `my_uniq` method
# to Array:
#
# ```ruby
# class Array
#   def my_uniq
#     # ...
#   end
# end
# ```
#
# This is also called *monkey patching*, and it is often frowned upon
# to, after-the-fact, add new methods to a class. However, it is
# occasionally useful and interesting to try out.
describe "#my_uniq" do
  it "uniqfies an array" do
    my_uniq([1, 1, 2, 3, 1]).should == [1, 2, 3]
  end
end

# Write a new `two_sum` method that finds all pairs of positions where
# the elements at those positions sum to zero.
#
# NB: ordering matters. I want each of the pairs to be sorted
# smaller index before bigger index. I want the array of pairs to be
# sorted "dictionary-wise":
#
# * [0, 2] before [2, 1] (smaller first elements come first)
# * [0, 1] before [0, 2] (then smaller second elements come first)
describe "#two_sum" do
  it "returns positions of pairs of numbers that add to zero" do
    two_sum([5, 1, -7, -5]).should == [[0, 3]]
  end

  it "finds multiple pairs" do
    two_sum([5, -1, -5, 1]).should == [[0, 2], [1, 3]]
  end

  it "finds pairs with same element" do
    two_sum([5, -5, -5]).should == [[0, 1], [0, 2]]
  end

  it "returns [] when no pair is found" do
    two_sum([5, 5, 3, 1]).should == []
  end

  it "won't find spurious zero pairs" do
    two_sum([0, 1, 2, 3]).should == []
  end

  it "will find real zero pairs" do
    two_sum([0, 1, 2, 0]).should == [[0, 3]]
  end
end

# Write a method that takes an array of stock prices (prices on days 0,
# 1, ...), and outputs the most profitable pair of days on which to
# first buy the stock and then sell the stock.
describe "#stock" do
  it "solves a simple case" do
    pick_stocks([3, 1, 4, 6, 0]).should == [1, 3]
  end

  it "returns nil if no profitable day" do
    pick_stocks([4, 3, 2, 1]).should be_nil
  end
end

# To represent a *matrix*, or two-dimensional grid of numbers, we can
# write an array containing arrays which represent rows:
#
# ```ruby
# rows = [
#     [0, 1, 2],
#     [3, 4, 5],
#     [6, 7, 8]
#   ]
#
# row1 = rows[0]
# row2 = rows[1]
# row3 = rows[2]
# ```
#
# We could equivalently have stored the matrix as an array of
# columns:
#
# ```ruby
# cols = [
#     [0, 3, 6],
#     [1, 4, 7],
#     [2, 5, 8]
#   ]
# ```
#
# Write a method, `my_transpose`, which will convert between the
# row-oriented and column-oriented representations.
describe "#my_transpose" do
  it "transposes a square matrix" do
    transpose(
      [ [3, 2, 1],
        [4, 5, 6],
        [7, 8, 9] ]
    ).should == [
      [3, 4, 7],
      [2, 5, 8],
      [1, 6, 9]
    ]
  end
end
