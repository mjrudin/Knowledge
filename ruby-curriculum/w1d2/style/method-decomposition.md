# Method Decomposition & Design

## Methods should be atomic

**Each method should do one thing.** A method should do a single,
atomic thing (we will often refer to this as the *Single
Responsibility Principle*). This may be one line of code, or three,
but rarely more than ten. **Methods should be short.** Let's take a
look at an example of refactoring one long method into short, atomic
methods.  We'll use an implementation of the Mixology exercise we
worked on in the [methods][methods] section.

[methods]: ../language-basics/methods.md

Here's the problem description in case you don't remember it:

The method `remix` should take an array of ingredient arrays (one
alcohol, one mixer) and return the same type of data structure, with
the ingredient pairs mixed up. Assume that the first item in the pair
array is alcohol, and the second is a mixer. Don't pair an alcohol
with an alcohol with or a mixer with a mixer. An example run of the
program:

```ruby
remix([
  ["rum", "coke"],
  ["gin", "tonic"],
  ["scotch", "soda"]
])
#=> [["rum, "tonic"], ["gin", "soda"], ["scotch", "coke"]]
```

Here's an example of a one-method solution:

```ruby
def remix(drinks)
  alcohols = []
  mixers = []

  drinks.each do |drink|
    alcohols << drink.first
    mixers << drink.last
  end

  alcohols.shuffle!
  mixers.shuffle!

  remixed_drinks = []
  alcohols.length.times do
    remixed_drinks << [alcohols.pop, mixers.pop]
  end

  remixed_drinks
end
```

Let's start breaking this method into smaller methods. What are the
steps that we take in this one super long method?

1. Split the drinks into arrays of alcohols and mixers
2. Shuffle the alcohol and mixer arrays
3. Zip the two arrays into a (now remixed) drinks array
4. Return the remixed drinks array

Now that we've listed the atomic steps, it will be easy to split the
method into smaller methods. Let's go step by step, and start by
extracting the `split_ingredients` method:

```ruby
def remix(drinks)
  alcohols, mixers = split_ingredients(drinks)

  alcohols.shuffle!
  mixers.shuffle!

  remixed_drinks = []

  alcohols.length.times do
    remixed_drinks << [alcohols.pop, mixers.pop]
  end

  remixed_drinks
end

def split_ingredients(drinks)
  alcohols = []
  mixers = []

  drinks.each do |drink|
    alcohols << drink.first
    mixers << drink.last
  end

  [alcohols, mixers]
end
```

Notice that we're using parallel assignment (aka array destructuring),
here: `split_ingredients` returns an array with `alcohols` and
`mixers` subarrays. We use parallel assignment to assign these
subarrays to `alcohols` and `mixers` variables that are local to the
`remix` method.

Shuffle is already an atomic method, so no need to refactor that step.
Let's extract a method to build the shuffled drinks array.

```ruby
def remix(drinks)
  alcohols, mixers = split_ingredients(drinks)

  alcohols.shuffle!
  mixers.shuffle!

  combine_ingredients(alcohols, mixers)
end

def split_ingredients(drinks)
  alcohols = []
  mixers = []

  drinks.each do |drink|
    alcohols << drink.first
    mixers << drink.last
   end

  [alcohols, mixers]
end

def combine_ingredients(alcohols, mixers)
  drinks = []

  alcohols.length.times do
    drinks << [alcohols.pop, mixers.pop]
  end

  drinks
end
```

Notice that the return value of `combine_ingredients` is the `drinks`
array, so we no longer need to explicitly return `remixed_drinks` in
the `remix` method!

Take a look at the `remix` method:

```ruby
def remix(drinks)
  alcohols, mixers = split_ingredients(drinks)

  alcohols.shuffle!
  mixers.shuffle!

  combine_ingredients(alcohols, mixers)
end
```

**It reads like plain English.** Hiding away our implementation
details in well-named helper methods both reduced the length of
`remix` and made its structure more transparent. If somebody looks at
this code, they will immediately understand what is going on, even
without reading the definitions of `split_ingredients` and
`combine_ingredients`.  This makes it a lot easier to understand code.

If they are interested in the implementation of a *specific action*,
they know where to find it: localized to an atomic, helper method.

## Do not use global state

A good general goal is that your methods should be like a mathematical
function: it should take something in and return something. It should
not rely on anything besides what is explicitly passed in, and it
should not have side-effects; it should communicate its result through
the return value.

Some languages are stricter than Ruby: they don't allow you to use any
data except what is passed in as an argument, and they don't let you
change any outside ("global") variables variables, or communicate
outside except through the return value. Ruby is more flexible, but
the majority of methods should be written in this style.

Simply put: **the only way in should be the arguments, the only way
out should be the return value**.

Here's an example of something super terrible:

```ruby
# create a global i variable
i = nil

def square_then_add_two(num)
  i = num
  square

  i = i + 2
end

def square
  # get global variable, square it, and reset
  i = i * i

  nil
end
```

First, `square` relies on a *global* variable. This should have been
passed in directly. Everything that a method needs should be declared
up-front as a parameter to the method. This makes it easier to know
how to call the method: just pass in the listed arguments.

Second, `square` doesn't return anything useful; instead, it
communicates by setting a global variable. That is unnecessarily
convoluted; just give the answer back directly.

A general guideline, avoid global state. Don't use global variables to
get around passing in arguments or return values.

## Don't modify arguments

Callers do not typically expect you to modify an argument. For
instance:

```ruby
def sum(array)
  result = 0

  while array.length > 0
    result += array.pop
  end

  result
end
```

This destroys the caller's array. Did they expect this? If modification
of the argument is essential to what you're doing, fine, but otherwise
don't do something potentially unexpected and dangerous like this.

Instead do something like:

```ruby
def sum(array)
  result = 0

  array.each { |val| result += val }

  result
end
```

## Resources

* [Wikipedia: Side effect][wiki-side-effects]
* [Destructuring with Ruby][destructuring]

[wiki-side-effects]: http://en.wikipedia.org/wiki/Side_effect_(computer_science)
[destructuring]: http://tony.pitluga.com/2011/08/08/destructuring-with-ruby.html
