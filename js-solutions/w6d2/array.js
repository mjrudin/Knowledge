// dups
Array.prototype.removeDups = function() {
  var uniques = [];

  for (var i = 0; i < this.length; i++) {
    if (uniques.length === 0 || uniques.indexOf(this[i]) === -1) {
      uniques.push(this[i]);
    }
  }

  return uniques;
};

// two sum
Array.prototype.twoSum = function() {
  for (var i = 0; i < this.length; i++) {
    for (var j = (i + 1); j < this.length; j++) {
      if (this[i] + this[j] === 0) {
        return true;
      }
    }
  }

  return false;
};

// transpose
Array.prototype.transpose = function() {
  var matrix = [];

  for (var i = 0; i < this.length; i++) {
    matrix.push([]);

    for (var j = 0; j < this.length; j++) {
      matrix[i].push(this[j][i]);
    }
  }

  return matrix;
};