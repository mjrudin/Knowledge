# Calling a function: let me count the ways

* Function-style (`fun(arg1, arg2)`)
    * `this` is set to `window`
* Method-style (`obj.method(arg1, arg2)`)
    * `this` is set to `obj`
* Constructor-style (`new ClassName(arg1, arg2)`).
    * Creates a new, blank object.
    * Sets its `__proto__` property to `ClassName`.
    * The `ClassName` function is called with `this` is set to the
      blank object.
        * Your constructor function should setup the variables.
        * Inside is like the `initialize` method from Ruby
        * The return value is ignored.

## Two last ways to call functions

Let me regale you with two more way to call a function: `apply` and
`call`. You will not use these very commonly, but you will see them in
library code that you read. They are quite simple.

### Apply

`.apply()` takes two arguments: an object to bind `this` to, and an
array of arguments to be passed to the method `.apply()` is being
called on. This is what it looks like:

```javascript
obj = {
  name: "Earl Watts"
};

function greet(msg) {
  console.log(msg + ": " + this.name);
}

// Using apply gratuitously:
greet.apply(obj, ["hello"]);
```

Ok, so what's going on here? Let's start with the first argument that
got passed, `obj`. `.apply()` wants to know what object to bind `this`
to. `apply` simulates calling `greet` as a method on `obj`. This is
sort of like saying `obj.greet("hello")`, except `greet` isn't an
attribute of `obj`, so we can't call it that way exactly.

### Call

`.call()` is really similar to `.apply()`, but instead of taking in an
array of parameters, it takes them individually. For example:

```javascript
obj = {
  name: "Earl Watts"
};

function greet(msg1, msg2) {
  console.log(msg1 + ": " + this.name;
  console.log(msg2 + ": " + this.name;
}

// Using call gratuitously:
greet.call(obj, "hello", "goodbye");
```

Why use `.call()` since `.apply()` seems more flexible? There is a
slight performance cost to using `.apply()` because the arguments need
to be unpacked. Don't worry about that; I just want you to understand
why there is such a similar method.

## Exercises

* Write your own version of `bind`. Add it to
  `Function.prototype`. This is trivial to do if you use `Function#apply`.
