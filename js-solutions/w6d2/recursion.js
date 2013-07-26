// sum array
function sumArray(arr) {
  if (arr.length === 0) {
    return 0;
  }

  return arr[0] + sumArray(arr.slice(1, arr.length));
}

// exponent
function exponent(base, power) {
  if (power === 0) {
    return 1;
  } else {
    return base * (expOne(base, (power - 1)));
  }
}

// fibonacci
function fibonacci(num) {
  if (num == 1) {
    return [0];
  } else if (num == 2) {
    return [0, 1];
  } else {
    var fibs = fibonacci(num - 1);
    fibs.push(fibs[fibs.length - 2] + fibs[fibs.length - 1]);

    return fibs;
  }
}

// binary search
function binarySearch(nums, target) {
  if (nums.length === 0) {
    return -1;
  }

  var midpoint = Math.floor(nums.length / 2);

  if (nums[midpoint] == target) {
    return midpoint;
  } else if (nums[midpoint] > target) {
    return binarySearch(nums.slice(0, midpoint), target);
  } else {
    return binarySearch(nums.slice(midpoint, nums.length), target) + midpoint;
  }
}