# Metaprogramming Ruby

One of Ruby's most powerful features is metaprogramming - that is,
the ability of the code to examine itself at runtime and dynamically
call and generate new methods. That means you can write code that
writes code. Whoa. Code that writes code? Now that's programming
Nirvana.

*NB: Code that writes code is called a* **macro**.

We've actually already seen a library that uses lots of metaprogramming
to get its job done: RSpec. By the end of this reading, you should have
a good idea of how RSpec actually implements its fancy (`be_valid` or
`be_X`) matcher that ends up calling `valid?` or `X?` on the object.
That's just one example of its use of metaprogramming.

Metaprogramming is also often used to DRY up repetitive code (think
about how similar all of the model classes from the SQL Questions
project were). That's a big part of what we'll be doing today.

## `send`

Consider `send` the metaprogramming workhorse of Ruby
applications. Its function is simple but powerful: it can call
arbitrary methods on Ruby objects.

Let's take a look at the method definition in [`ruby-doc`][send-doc]:

```
send(symbol [, args...])
send(string [, args...])

Invokes the method identified by symbol, passing it any arguments
specified.
```

`send` will take a symbol and call that method on the object that
invoked send, along with the arguments.

**NB:** In `send(symbol [, args…])`, the `args` are in brackets. The
brackets indicate that the argument is optional. Furthermore, `args`
is followed by `…`, which indicates that the methods can take
unlimited additional arguments. How many would you want to have?
Well, as many as the method you're invoking needs.

Let's look at a simple example:

```
class Dog
  def say_hi
    puts 'Ruff!'
  end
end
```

What would `Dog.new.send(:say_hi)` generate?

```
>> Dog.new.send(:say_hi)
Ruff!
=> nil
```

`send` simply invokes the method on the calling object.

Let's look at another example:

```
class Dog
  def say_something(something_to_say)
    puts something_to_say
  end
end
```

```
>> Dog.new.send(:say_something, 'I can talk!')
I can talk!
=> nil
```

Cool.

What would happen if you called `send` with a symbol that doesn't
actually reference a real method?

```
>> Dog.new.send(:dance, :funky_chicken)
NoMethodError: undefined method `dance' for #<Dog:0x007fee758c34b0>
```

Exactly what would have happened if we called
`Dog.new.dance(:funky_chicken)`: it would raise a `NoMethodError`.

When is something like send useful? Why not just call the method the
normal way? Well, using `send` lets us write methods like this:

```
def do_three_times(object, method_name)
  3.times { object.send(method_name) }
end
```

`send` also has one other special property: it totally disregards
whether a method is protected or private. This is a powerful feature,
but tread carefully when doing this.

```
class User
  attr_reader :bankroll

  def initialize
    @bankroll = 100
  end

  private
  def deduct_payment(amt)
    @bankroll -= amt
  end
end

>> u = User.new
>> u.deduct_payment(50)
NoMethodError: private method `deduct_payment' called for #<User:0x007fd90bacac88 @bankroll=100>
>> u.bankroll
100

>> u = User.new
>> u.send(:deduct_payment, 50)
=> 50
>> u.bankroll
=> 50
```

[send-doc]: http://ruby-doc.org/core-1.9.3/Object.html#method-i-send

## `define_method`

`define_method` is where the real magic starts to happen. With this
method, you can dynamically generate new instance methods for a
class.

Let's go to the [`ruby-doc`][define_method-doc] once again to take a
look at `define_method`:

```
define_method(symbol, method)
define_method(symbol) { block }

Defines an instance method in the receiver. The method parameter can
be a Proc, a Method or an UnboundMethod object. If a block is
specified, it is used as the method body.
```

Okay, that reads a little complicated. But here's the basics: you call
`define_method` on the class, you give it a name for the method, and
then you pass a block, which is what will be executed when the method
is called.

Let's take a look at a simple example:

```
class Dog
  define_method(:bark) do
    puts 'Ruff!'
  end
end

>> Dog.new.bark
'Ruff!'
=> nil
```

Remember, `define_method` creates **instance** methods in the
receiver, so, for the most part, you want to make sure you're always
calling `define_method` on a class.

Note that when you call a method inside a class definition, it is
called on the class itself. So the above example called
`define_method` on the `Dog` class, defining a new instance method
`Dog#bark`.

What would happen if we simply called `define_method` on `Dog`?

```
>> Dog.define_method(:bark) do
     puts 'Ruff!'
   end
NoMethodError: private method `define_method' called for Dog:Class
```

Ah, `define_method` is a private method, so keep in mind that it can
only be called within the class definition.

One last gotcha about private methods: not only are they not
accessible outside the class, they must also be called implicitly:

```
[1] pry(main)> class Dog
[1] pry(main)*   self.define_method(:bark) do
[1] pry(main)*     puts 'Ruff!'
[1] pry(main)*   end
[1] pry(main)* end
NoMethodError: private method `define_method' called for Dog:Class
         from: (pry):2:in `<class:Dog>'
```

When calling a private method, you must not use `self`.

[define_method-doc]: http://ruby-doc.org/core-1.9.3/Module.html#method-i-define_method
[has_many-doc]: http://guides.rubyonrails.org/association_basics.html#has_many-association-reference

## Class Instance Variables

Huh? I thought the whole point of instance variables was to maintain
state for an object, not a class.

Ah, well Kimosabe, **a class is an object, too**.

Let's say we have a class `Dog` and we wanted to keep a count of the
number of `Dog`s that had been created. How might we do that? Well,
here's one way using a class instance variable:

```
class Dog
  # instance variable used in class context (that is, `self` is a
  # class) means that `@dog_count` is an instance variable of the
  # class.
  @dog_count = 0

  # override `Dog.new` to track the number of dogs
  def self.new
    # construct a dog as usual
    new_dog = super

    # we're in a class method; `@dog_count` increments the class var
    @dog_count += 1

    # return the dog per usual
    new_dog
  end
end
```

What have we done here? First, we create an instance variable out in
the class definition. Since the context (i.e. what `self` is) out in
the class definition is the class itself (i.e. `Dog`), the instance
variable belongs to the class object.

Then we override the `Dog::new` method. We're not trying to change the
functionality of `new` very much; we just want to increment a counter
each time a `Dog` is created. Therefore, we call `super` to invoke
the `new` method that existed before we overrode it, store the
new `Dog` instance it creates in a variable, increment the class
instance variable `@dog_count` by 1, and then return the new `Dog`
instance.

Okay, great, but how do we get access to the count?

```
class Dog
  @dog_count = 0

  def self.new
    new_dog = super
    @dog_count += 1
    new_dog
  end

  def self.count
    @dog_count
  end
end
```

Let's give it a whirl!

```
>> Dog.new
=> #<Dog:0x007ff2f1957400>
>> Dog.new
=> #<Dog:0x007ff2f19502b8>
>> Dog.new
=> #<Dog:0x007ff2f19494b8>
>> Dog.count
=> 3
```

Success!

So, remember that a class in Ruby is an object, and objects can have
instance variables. If you need to maintain some information at the
class level, as opposed to the instance level, consider using a class
instance variable.

**NB**: For those of you who want to go down the rabbit hole of Ruby's
object model, refer to [this][so-answer],
[this][skilldrick-object-model], and
[this][hokstad-object-model]. Don't worry about this stuff though -
it's not crucial information, but it is interesting to know.

[so-answer]: http://stackoverflow.com/questions/10558504/can-someone-explain-the-class-superclass-class-superclass-paradox
[skilldrick-object-model]: http://skilldrick.co.uk/2011/08/understanding-the-ruby-object-model/
[hokstad-object-model]: http://www.hokstad.com/ruby-object-model
