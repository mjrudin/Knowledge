////////////////////////////////////////
Array.prototype.dups = function() {
  var unique_array = [];

  for (var i = 0; i < this.length; i++) {
    if (unique_array.indexOf(this[i]) === -1) {
      unique_array.push(this[i]);
    }
  }
  return unique_array;
};

console.log([1,1,2,2,3,3,4,4,5,5].dups());
////////////////////////////////////////

Array.prototype.two_sum = function() {
  var pairs = [];

  for (var i = 0; i < this.length; i++ ) {
    for (var j = i+1; j < this.length; j++) {
      if (this[i] + this[j] === 0) {
        pairs.push([i,j])
      }
    }
  }
  return pairs
};

console.log([-1, 0, 2, -2, 1].two_sum());
////////////////////////////////////////

Array.prototype.transpose = function() {
  var columns = [];
  for (var i = 0; i < this[0].length; i++) {
    columns.push([]);
  }

  for (var i=0; i < this.length; i++) {
    for (var j=0; j < this[i].length; j++) {
      columns[j].push(this[i][j]);
    }
  }
  return columns  
};

console.log([[0, 1, 2], [3, 4, 5],[6, 7, 8]].transpose());
////////////////////////////////////////