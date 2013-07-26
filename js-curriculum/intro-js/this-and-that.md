# `this` and `that`

We've learned about the special `this` variable. When we call a
function "method style" (`object.method()`), the special variable
`this` gets set to `object`. `this` is a lot like `self` in Ruby.

There is one evil thing about `this`, and it comes up when we pass
callbacks. Observe, dear reader:

```javascript
function times(num, fun) {
  for (var i = 0; i < num; i++) {
    // call the function
    fun(); // call is made "function-style"
  }
}

var cat = {
  age: 5,

  age_one_year: function () {
    this.age += 1;
  }
};

cat.age_one_year(); // works

times(10, cat.age_one_year); // does not work!
```

The first call to age the cat works. But the calls to increment the
cat's age ten times don't.

```
~$ node test.js
{ age: 6, age_ten_years: [Function] }
```

The `age_one_year` method uses the special `this` variable. But the
`this` variable **will not be set properly unless we call a function
"method-style"**.

```javascript
obj.method(); // called method style; `this` set properly

var m = obj.method;
m(); // called function style; `this` not set
```

In the example, we pull out the `cat.age_one_year` method and pass it
to `times`. `times` calls the method, **but it calls it
function-style**. When we call a function "function-style", `this` is
set to `window`, which is a special, top-level JavaScript
variable. More simply, `this` will not be set to `cat`.

There are two ways around this problem. The first is to introduce a
closure to capture `cat`:

```javascript
// This bit is the same:
function times(num, fun) {
  for (var i = 0; i < 10; i++) {
    // call the function
    fun(); // call is made "function-style"
  }
}

var cat = {
  age: 5,

  age_one_year: function () {
    this.age += 1;
  }
};

// This bit is different:
times(10, function () {
  cat.age_one_year();
});
```

`times` will still call the passed function function-style, so `this`
will still be set to `window`. But the closure doesn't care, **because
inside it explicitly calls `age_one_year` method style on `cat`**.

This is a very common pattern, so there is another, less verbose
alternative:

```javascript
times(10, cat.age_one_year.bind(cat));
```

`bind` is a method you can call on JS functions. JS functions are
objects, too! You can add new methods to `Function.prototype`.

`bind` creates the anonymous function we had made by hand, in which
the function `cat#age_one_year` is called method style on the `cat`
object. The function returned by `cat.age_one_year.bind(cat)` will
still be called function style, but inside it will call `age_one_year`
on `cat` method style.

Note that we could do crazy things like this:

```javascript
var crazyMethod = cat.age_one_year.bind(dog);
```

Here, `crazyMethod()` will call the `Cat#age_one_year` method, but
`this` will be bound to the object `dog`. You don't want to do this,
but I want to illustrate how the `bind` method works.

## More trouble

Let's see the same problem in another context:

```javascript
function SumCalculator() {
  // scope 0
  this.sum = 0;
}

SumCalculator.prototype.addNumbers = function (numbers) {
  // scope 1
  _.each(numbers, function (number) {
    // scope 2
    this.sum += number; // noooo!
  });
    
  return this.sum;
};
```

For the same reason as before, the use of `this` in scope 2 will not
work. Because the anonymous function will not be called method style
by `_.each`, the special `this` variable will not be set
properly. That makes all the sense in the world: since the anonymous
function is not even a method of `SumCalculator`!

This problem can be hard to spot, because even though we are using
`this` in a method of `SumCalculator`, we're also inside an anonymous,
nested function which will be called function style. That makes it
hard to spot. In particular, the correct use of `this` in scope 1 will
mean something different than the incorrect use in scope 2.

This sort of runs counter to the philosophy of closures: that they can
access variables defined in the enclosing scope. `this` is special
because it doesn't get captured; it gets reset everytime a function is
called.

The typical solution is to introduce a normal variable to hold `this`
in a way that can be captured:

```javascript
function SumCalculator() {
  // scope 0
  this.sum = 0;
}

SumCalculator.prototype.addNumbers = function (numbers) {
  var that = this;

  _.each(numbers, function (number) {
    that.sum += number; // will work as intended
  });
    
  return that.sum;
};
```

Because `that` is a typical variable, it can be captured and used by
the closure. Later, when the closure is called function style, it
won't matter, because instead of using `this` (which would have been
reset to `window`), we instead use `that`, which holds the old
reference to the `SumCalculator` object that `addNumbers` was called
on.

`that` is just a conventional name, there is no magic to it. A
somewhat less common name is `self`.

The reason this solution works is because `that` is a normal variable
captured according to typical rules, while `this` is a special
variable **which is never captured and is reset on every function
call**.

The solution stinks, but it's just the way things are. I never use
`this` inside a method; the first line of every method I write is `var
that = this;`. Then, inside the method, I use `that` everywhere; never
`this`. Doing so means you can avoid have the `this` problem
altogether; by never using it directly.
