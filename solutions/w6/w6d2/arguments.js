var US = require("./underscore.js")

// helper function.
var sumArray = function(numbers) {
  return US.reduce(numbers, function(memo, num){ return memo + num; }, 0);
}

// Write a sum method. This should take any number of arguments:
// > sum(1, 2, 3, 4) == 10
// true
var sum = function() {
  return sumArray(arguments);
}

// Exercise: Rewrite your bind method so that it can optionally take
// some args to be partially applied.
Function.prototype.myBindWithArgs = function(context) {
  var that = this; // "that" is now the function that we are binding.
  // Note that arguments is not actually an array, so we have to call
  // slice on it to get its items into an array.
  var args = Array.prototype.slice.call(arguments, 1);
  return function() {
    return that.apply(context, args.concat(Array.prototype.slice.call(arguments)));
  };
}

// Write a curriedSum function that takes an integer (that represents
// how many numbers will ultimately be summed) and returns a function
// that can be successively called with single arguments until it
// finally returns a sum.
var curriedSum = function (n) {
  var numbers = [];
  var sumFun = function (x) {
    numbers.push(x);
    if (numbers.length == n) {
      return sumArray(numbers);
    }
    return sumFun;
  };
  return sumFun;
};

// Write a function curry that takes a function and an integer (that
// represents the number of arguments the function ultimately takes)
// and returns a curried version of the function.
var curry = function (funct, numArgs) {
  var args = [];
  var curriedFun = function (arg) {
    args.push(arg);
    if (args.length === numArgs) {
      return funct.apply(null, args);
    }
  }
  return curriedFun;
};
