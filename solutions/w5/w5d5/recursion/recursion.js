// Node reserves the _ keyword to represent the last thing returned
// so when using node, we need to refer to underscore as US, not _.
var US = require('./underscore.js');

// Write a recursive method, range, that takes a start and an end and
// returns an array of all numbers between.
var range = function(start, end) {
  return end === start ? [start] : range(start, end - 1).concat(end);
};

// Write both a recursive and iterative version of sum of an array.
var sumrec = function(numbers) {
  if (numbers.length === 0) {
    return 0;
  }
  var lastNum = numbers.pop();
  return sumrec(numbers) + lastNum;
};

var sumiter = function(numbers) {
  var sum = 0

  US(numbers).each(function(number) {
    sum += number
  })
    return sum
};

// Write two versions of exponent that use two different recursions:
// recursion 1
// exp(b, 0) = 1
// exp(b, n) = b * exp(b, n - 1)
var exprec1 = function(b, n) {
  return n === 0 ? 1 : b * exprec1(b, n - 1);
};

// recursion 2
// exp(b, 0) = 1
// exp(b, n) = exp(b, n / 2) ** 2             [for even n]
// exp(b, n) = b * (exp(b, (n - 1) / 2) ** 2) [for odd n]
var exprec2 = function(b, n) {
  if (n === 0) {
    return 1;
  }

  if (n % 2 === 0) {
    var subproblem = exprec2(b, n / 2);
    return subproblem * subproblem;
  } else {
    var subproblem = exprec2(b, ((n - 1) / 2));
    return subproblem * subproblem * b;
  }
};

// Write a recursive and an iterative Fibonacci method. The method
// should take in an integer n and return the first n Fibonacci numbers
// in an array.
var fibrec = function(n) {
  if (n < 3) {
    return [0,1].slice(0,n);

  } else {
    var fibs = fibrec(n-1);
    fibs.push(fibs[fibs.length - 1] + fibs[fibs.length - 2]);

    return fibs;
  }
};

var fibiter = function(n) {
  var fibs = [0,1];

  while (fibs.length < n) {
    fibs.push(fibs[fibs.length - 1] + fibs[fibs.length - 2]);
  }

  return fibs
};

// Write a recursive binary search: bsearch(array, target). Note that
// binary search only works on sorted arrays. Make sure to return the
// location of the found object (or nil if not found!).
var bsearch = function(numbers, target) {

  if (numbers.length < 2 && numbers[0] != target) {
    return -1;
  }

  var probe_index = Math.floor(numbers.length / 2);
  var probe = numbers[probe_index];

  if (target === probe) {
    return probe_index;

  } else if (target < probe) {
    var left = numbers.slice(0, probe_index);

    return bsearch(left, target);

  } else {
    var right = numbers.slice(probe_index);
    var subproblem = bsearch(right, target);

    return subproblem < 0 ? subproblem : subproblem + probe_index;
  }
};

// Make Change
var makeChange = function(target, coins) {
  if (target === 0) {
    return [];
  }

  var bestChange;

  US(coins.sort().reverse()).each(function(coin, index) {
    if (coin <= target) {
      var remainder = target - coin;
      var restChange = makeChange(remainder, coins.slice(index));

      var change = [coin].concat(restChange)

      if (!bestChange || change.length < bestChange.length) {
        bestChange = change;
      }
    }
  })

    return bestChange;
};

// Implement a method, merge_sort that sorts an Array. Hint: The base
// case for this sort is surprisingly simple.

// First we write our sorted merge helper function.
var merge = function(left, right) {
  var merged = [];

  while (left.length > 0 && right.length > 0) {
    var nextItem = left[0] < right[0] ? left.shift() : right.shift();
    merged.push(nextItem);
  }

  return merged.concat(left).concat(right);
};

var mergeSort = function(array) {
  if (array.length < 2) {
    return array;
  } else {
    var middle = Math.floor(array.length/2);

    var left = mergeSort(array.slice(0, middle));
    var right = mergeSort(array.slice(middle));

    return merge(left, right);
  }
};

// Write a method, subsets, that will return all subsets of an array.
var subsets = function(array) {
  if (array.length === 0) {
    return [[]];
  }
  var lastElement = array.pop();
  var subSubsets = subsets(array)

  var newSubsets = US(subSubsets).map(function(subSubset) {
    return subSubset.concat(lastElement);
  });

  return newSubsets.concat(subSubsets);
};
