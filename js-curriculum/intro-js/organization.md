# Organizing JS libs

## Namespacing

In early days, there was a common problem with JavaScript namespacing:

```javascript
// library1
function each(arr) {
  // ...
}

// library2
function each(arr) {
  // ...
}
```

The problem is that the two libraries both define an `each` function
at the top level. Whichever library loads last will overwrite the
other's version of `each`.

The solution is to *namespace* the library code:

```javascript
var LibraryOne = {};

LibraryOne.each = function () {
  // ...
};

var LibraryTwo = {};

LibraryTwo.each = function () {
  // ...
};
```

Now we need to say `LibraryOne.each` or `LibraryTwo.each`, but the two
do not collide. This is what jQuery and underscore do (with variables
named `$` and `_`, for conciseness).

It is common for all the methods defined in a library to be namespaced
under a single top-level name.

## Anonymous function trick

Namespacing is important, but it can be a little annoying:

```javascript
var LongLibraryName = {};

LongLibraryName.func1 = function () {
  // do work
};

LongLibraryName.func2 = function () {
  LongLibraryName.func1();
  LongLibraryName.func1();
  LongLibraryName.func1();
};
```

To solve this problem we define the library functions in an enclosing
anonymous function, which then returns the exported functions. Easier
shown than said:

```javascript
(function () {
  window.LongLibraryName = {};

  var func1 = LongLibraryName.func1 = function () {
    // do work
  }
  
  var func2 = LongLibraryName.func2 = function () {
    func1();
    func1();
    func1();
  }
})();
```

The anonymous function is immediately called; the library functions
get defined inside the anonymous function. They can "see" each other
and call each other because they are all being defined and stored in
variables in the same scope.
