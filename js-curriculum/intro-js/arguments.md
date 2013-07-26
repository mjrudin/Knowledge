# Arguments in Javascript

Arguments in JS behave differently than they do in other languages.
Namely, JavaScript functions will happily take fewer arguments than
specified (in which case the unspecified arguments have value
`undefined`), or extra arguments (they will be available in an
`arguments` array).

## Multiple Arguments

JS functions will accept more arguments than are asked for. You have
access to these bonus arguments through a special array called
`arguments`. Like the `this` keyword, `arguments` is set each time you
call a function. It contains the values of all the arguments: ones
that were anticipated in the function definition, plus the extras.

as an array within the function. In
fact, you are able to access this array in your function by calling
`arguments` within your function.

```javascript
function alertArguments() {
  for (var i = 0; i < arguments.length; i++) {
    console.log(arguments[i]);
  }
};

alertArguments("boop", "candle", 3);
```

## No Arguments 

JS functions can also take fewer arguments than expected. In that
case, unspecified arguments have the value `undefined`.

```javascript
var id = function(arg) {
  return arg; 
}

id(5); // => 5
id(); // => undefined
```

Ocasionally this can be infuriating to debug when you expect a
function to throw an error when it doesn't receive as many arguments
as it requires to return the correct output. Always keep in mind that
a function will still run even if it has been passed no arguments at
all.

## Exercises

### `sum`

Write a `sum` method. This should take any number of arguments:

    sum(1, 2, 3, 4) == 10
    sum(1, 2, 3, 4, 5) == 15

### `bind` with args

**Exercise:** Rewrite your `bind` method so that it can optionally take some
args to be partially applied.

For example:

```javascript
var myBoundFunction = myFunction.bind(myObj, 'hi', 'bye');

// equivalent to obj.myFunction("hi", "bye", "lastArg")
myBoundFunction('lastArg');
```

### `curry`

In functional programming, a common pattern is currying. Currying is
the process of decomposing a function that takes multiple arguments
into one that takes single arguments successively until it has the
sufficient number of arguments to run.

Here's an example of two functions being called that both sum 3
numbers. The first is the typical version that takes 3 arguments; the
second is a curried version:

```
sum(4, 20, 3); // == 27

curriedSum(4)(20)(3); // == 27
```

Note that the curried version returns functions at each step until it
has the 3 arguments it needs, at which point it actually returns the
calculated sum.

**Exercise:** Write a `curriedSum` function that takes an integer
(that represents how many numbers will ultimately be summed) and
returns a function that can be successively called with single
arguments until it finally returns a sum.

That is:

```
var sum = curriedSum(4);
sum(5)(30)(20)(1); // => 56
```

Hint: `sum(5)` should return a closure that:

* captures an array in which the arguments will be added one-by-one
* returns itself (the closure returns the closure itself) until the
  array reaches the appropriate size
* when the array of collected arguments reaches the appropriate size,
  calculates and returns the sum.

**Exercise:** Write a function `curry` that takes a function and an
integer (that represents the number of arguments the function
ultimately takes) and returns a curried version of the function.

Eventually, after you have collected enough arguments, you'll have to
evaluate the original function. You'll want to use `apply` for this, I
think.
