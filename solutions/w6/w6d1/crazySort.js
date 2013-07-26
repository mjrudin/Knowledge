var readline = require("readline");

var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function askLessThan(el1, el2, callback) {
  reader.question(
    "Is " + el1 + " less than " + el2 + "?: ",
    function (answer) {
      if (answer == "yes") {
        callback(true);
      } else {
        callback(false);
      }
    }
  );
}

// loop with non-blocking IO: callbacks that recursively call original
// method.

function crazySortHelper(arr, i, madeAnySwaps, passCompletionCallback) {
  // maybe swap two elements and then continue.
  
  if (i == (arr.length - 1)) {
    passCompletionCallback(madeAnySwaps);
    return;
  }
  
  console.log("Next comparison: " + i);
  
  askLessThan(arr[i], arr[i + 1], function (lessThan) {
    if (!lessThan) {
      var tmp = arr[i];
      arr[i] = arr[i + 1];
      arr[i + 1] = tmp;
      
      madeAnySwaps = true;
    }

    crazySortHelper(arr, i + 1, madeAnySwaps, passCompletionCallback);
  });
}

function crazySort(arr, sortCompletionCallback) {
  console.log("Next pass: " + arr);
  crazySortHelper(arr, 0, false, function (madeAnySwaps) {
    if (madeAnySwaps) {
      crazySort(arr, sortCompletionCallback);
    } else {
      sortCompletionCallback(arr);
    }
  });
}

// crazySort([3, 2, 1], function (arr) {
//   console.log("We finished!");
//   console.log(arr);
// });
// 
// console.log("executed still pretty early");
// 

function addSomeNumbers(sum, numsLeft, callback) {
  if (numsLeft > 0) {
    reader.question("Give me num: ", function (numStr) {
      var thisNumber = parseInt(numStr);
      addSomeNumbers(sum + thisNumber, numsLeft - 1, callback);
    })
  } else {
    callback(sum);
  }
}

addSomeNumbers(0, 4, function (sum) {
  console.log("You made it!");
  console.log(sum);
});
