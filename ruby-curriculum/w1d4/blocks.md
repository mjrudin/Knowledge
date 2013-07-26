# Blocks and Procs

## Goals

* Know how to define a block, especially one that takes arguments.
* Know how to write a method that takes a block.
* Know the difference between `Block`s and [`Proc`](http://ruby-doc.org/core-2.0/Proc.html)s.
* Know not to return from a block.
* Know what `#to_proc` and `&` are used for.

## Blocks! Blocks! Blocks!

Blocks, more than anything, are what makes Ruby unique. Blocks are
chunks of code that get passed into methods. Methods then *call* the
block to customize their own behavior.

For instance, take `Enumerable#map`:

```ruby
[1, 2, 3].map { |num| num + 1 } # => [2, 3, 4]
```

`map` applies a block to each element of the array. What it does with
each element depends on the block. For instance, instead of adding one
to each element, we could square them:

```ruby
[1, 2, 3].map { |num| num * num } # => [1, 4, 9]
```
Fundamentally, methods often take blocks to allow the user to
customize what the method will do.

## Block syntax

Blocks are either wrapped in curly braces, or with a "do" and
"end". We could write the previous example as:

```ruby
[1, 2, 3].map do |num|
  num * num
end # => [1, 4, 9]
```
Use braces for single-line blocks. *Always use do-end for longer blocks*.

Blocks are passed to a method, but they do not appear in the list of
arguments. They come after the closing parentheses, if there are any:

```ruby
3.times { puts "Hey, friend!" } # don't need parens when no args
3.times() { puts "Hey, friend!" } # if parens used block is given outside parens
```

Blocks may take arguments, just like methods do. The argument names
are wrapped in '|' (called *pipes*).

```ruby
[1, 2, 3].map { |num| num * num }
```
Here `map` is going to call the block repeatedly; it will pass in each
of the elements. Each time, the element (1, 2, or 3) will be *bound*
to the `num` argument declared between the pipes.

## Writing a method that takes a block

Blocks are passed to methods mostly like other arguments. Let's write
a method, `maybe` that will call a block only if its argument is
true. It should work like this:

```ruby
maybe(true) { puts "Hello!" } # runs block, since passed true
maybe(false) { puts "Goodbye!" } # doesn't run block
```

Here's how we would define maybe:

```ruby
def maybe(flag, &prc)
  prc.call if flag
end
```

Notice the `&prc` argument? The ampersand is a special symbol that
signifies that `prc` should hold a `Proc`. The block, if provided,
gets turned into a `Proc` object, which is then stored in the `prc`
variable; if no block is provided, `prc` is set to `nil`.

```ruby
def amp_makes_block_a_proc(&prc)
  puts &prc.class
end

amp_makes_block_a_proc {|x| x+1}
#=> Proc
```

What's the difference between a block and a `Proc`? A block is the
Ruby code you write; Ruby then creates an object that will store your
block so that you can call it later, a `Proc`. You can create a `Proc` object
yourself:

```ruby
my_proc = Proc.new { "Hey, friend!" }
my_proc.call # calls the block, which returns: "Hey, friend!"
my_proc.call # calls it again
```

`Proc#call` calls the block. Any arguments you pass to `call` will be
passed on to the block.

```ruby
my_new_proc = Proc.new { |name| puts "Hello #{name}" }
my_new_proc.call("Zimmy")
```

Takeaway: to store or use a block, it must first be turned into a
`Proc`, either explicitly (`Proc::new`) or implicitly (`&prc`
variable).

It may be worth noting that you can take multiple blocks by explicitly 
defining procs and then passing them into your method.

```ruby
proc_add_1 = Proc.new {|num| puts num + 1}
proc_add_2 = Proc.new {|num| puts num + 2}

def adding_method(array, proc1, proc2, &proc3)
  proc1.call(array[0])
  proc2.call(array[1])
  proc3.call(array[2])
end

adding_method([1,1,1,], proc_add_1, proc_add_2) do 
  |num| puts num + 3 
end
#=> 2
    3
    4
```

## yield

Ruby has a special syntax which simplifies passing blocks. You may use
the keyword `yield` to call the passed block without using a block
variable. Let's rewrite `maybe`:

```ruby
def maybe(flag)
  yield if flag
end
```

## Avoid return inside a block

Blocks implicitly return values like Ruby methods; the last value is
implicitly returned from the block.

```ruby
add_one = Proc.new { |num| num + 1 } # num + 1 will be returned
two = add_one.call(1)
```

This is how `Enumerable#map` works: it calls the block on each
element, using the returned value in the new collection.

Do not explicitly `return` from a block:

```ruby
[1, 2, 3].map { |num| return num + 1 } # surprise!
```

This will not merely return from the block, it will return from the
context where the block was defined. Huh? What does that mean?

The reason is not vital for you to know right now (so long as you know
not to use return in blocks!). You can skip the following if you
like; if you are curious, you read on.

```ruby
def wrap_block
  puts "Started at #{Time.now}."
  value = yield
  puts "Ended at #{Time.now}."

  value
end

# example 1
def test1
  value = wrap_block do
    1 + 1
  end

  puts "All done! Got value: #{value}."
end

# example 2
def test2
  value = wrap_block do
    # this is going to return immediately *from test2*
    # will not wait for printing end time, or "Never called!"
    return 1 + 1
  end

  puts "Never called!"
end

# example 3
wrap_block do
  # Throws exception:
  #     "LocalJumpError: unexpected return"
  # Does this because it wouldn't otherwise be legal to call return at
  # the top level of our Ruby code (outside a method).

  return 1 + 1
end
```

Tricky, tricky, tricky. We might have thought we could return from the
block as if we were in a new, anonymous method. Under this theory,
return would return just from the block.

This is not what a block does, though; as said, it will return from
the context where it was first defined. In example two, this results
in the unexpected behavior. In the third example, the block is defined
at the top level, where it is illegal to return. So this causes an
exception to be thrown.

When I learned Ruby, I was surprised by this behavior. I was used to
other languages (like Lisp and JavaScript) which led me to believe
return would only return from the block. Ruby does have a way to do
this (lambdas), but they are not as commonly used as blocks.

As you grow wise with age, you may learn to recognize times where it
might be convenient to return from a block and take advantage of this
feature. For myself, I don't do this, since it is somewhat unexpected
(by me, anyway). So even when it might be otherwise convenient, I want
to be sure not to confuse another reader (or myself!) when someone
comes back to my code.

## Symbols and blocks

Methods that take a block typically don't want to accept an explicit
`Proc` object:

```ruby
add_one = Proc.new { |i| i + 1}
[1, 2, 3].map(add_one) # wrong number of arguments (1 for 0)
```

We can ask a method to pass an argument into the block argument slot
by using the '&' symbol:

```ruby
[1, 2, 3].map(&add_one) # => [2, 3, 4]
```

Of course, we get yelled at if we try to pass both a `Proc` this way
in addition to a typical block:

```ruby
[6] pry(main)> [1, 2, 3].map(&add_one) { "an actual block!" }
SyntaxError: (eval):2: both block arg and actual block given
```

It's very, very common to have blocks that take an argument and call a
single method:

```ruby
["a", "b", "c"].map { |str| str.upcase } # upcase all strings
[1, 2, 5].select { |num| num.odd? }
```

In this case, Ruby gives us a shortcut:

```ruby
["a", "b", "c"].map(&:upcase)
[1, 2, 5].select(&:odd?)
```

When an item is passed to the block slot, it will have the method
`#to_proc` called on it. In the case of a `Proc`, this does
nothing. In the case of a `Symbol`, this returns a `Proc` which calls
a method on the `Proc`'s argument. So the above could be rewritten
more verbosely as:

```ruby
["a", "b", "c"].map { |s| s.upcase }
[1, 2, 5].select { |i| i.odd? }
```

Note: In order to convert a symbol to a string you can use `#to_s` or `#to_sym`
to go from string to symbol

## Required video

* Watch Peter talk about [it all][peter-youtube-blocks].

## Exercises 

Estimated time: 1hrs

* Implement new `Array` methods `my_each`, `my_map`, `my_select`. Do
  it by monkey-patching the `Array` class. Don't use any of the
  original versions when writing these. If you want to use `each` to
  define some of the others (good idea!), use your `my_each` method.
* Implement a `my_inject` method. Your version shouldn't take an
  optional starting argument; just use the first element. Ruby's
  `inject` is fancy (you can write `[1, 2, 3].inject(:+)` to shorten
  up `[1, 2, 3].inject { |sum, num| sum + num }`), but focus on the
  block (and not the symbol) version.
* Define your own `Array#my_sort!`: it should take in a block to
  perform the comparison:

```ruby
[1, 3, 5].my_sort! { |num1, num2| num1 <=> num2 } #sort ascending
[1, 3, 5].my_sort! { |num1, num2| num2 <=> num1 } #sort descending
```

  `#<=>` (the *spaceship* method)
  [compares objects][so-spaceship]. `x.<=>(y)` returns `-1` if `x` is
  less than `y`. If `x` and `y` are equal, it returns `0`. If greater,
  `1`. You can define `<=>` on your own classes.
  
  **Don't use `my_each` for this one!**
* Write a method that takes some arguments and a block. It should call
  the block, passing all the arguments to the block at once using the
  splat operator. If the user doesn't supply the block, it should
  print out "NO BLOCK GIVEN!".
    * To take possibly multiple arguments, check out the Ruby
      [splat operator][splat-operator].

[peter-youtube-blocks]: http://www.youtube.com/watch?v=VBC-G6hahWA
[splat-operator]: http://kconrails.com/2010/12/22/rubys-splat-operator/

## Resources
* [Robert Sosinski on Blocks][sosinski-blocks]
* [Skorks on Procs and Lambdas][skorks-blocks]

## Extra Credit
* Read [Fizzbuzz written entirely with Procs][fizzbuzz-procs]
  * [HN discussion on the above article][HN-fizzbuzz-procs]

[sosinski-blocks]: http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas
[skorks-blocks]: http://www.skorks.com/2010/05/ruby-procs-and-lambdas-and-the-difference-between-them/
[so-spaceship]: http://stackoverflow.com/questions/827649/what-is-the-ruby-spaceship-operator
[fizzbuzz-procs]: http://codon.com/programming-with-nothing
[HN-fizzbuzz-procs]: http://news.ycombinator.com/item?id=3343205
