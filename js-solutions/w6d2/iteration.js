// bubble sort
function bubbleSort(arr) {
  var copyArr = arr;
  var sorted = false;

  while (!sorted) {
    for (var i = 1; i < copyArr.length; i++) {
      sorted = true;

      if (copyArr[i - 1] > copyArr[i]) {
        var temp = copyArr[i - 1];
        copyArr[i - 1] = copyArr[i];
        copyArr[i] = temp;

        sorted = false;
      }
    }
  }

  return copyArr;
}

// substrings
function subStrings(word) {
  var substrings = [];

  for (var i = 0; i < word.length; i++) {
    for (var j = (i + 1); j < word.length; j++) {
      substrings.push(word.slice(i, j));
    }
  }

  return substrings;
}