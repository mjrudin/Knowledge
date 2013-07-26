////////////////////////////////////////
Array.prototype.multiples = function() {
  var multiple_array = [];

  for (var i=0; i < this.length; i++) {
    multiple_array.push(this[i] * 2);
  }
  return multiple_array;
};

console.log([1,2,3,4,5].multiples());
////////////////////////////////////////
Array.prototype.each = function(func) {
  for (var i=0; i < this.length; i++) {
    func(this[i]);
  }
  return this;
}

var arr = [1,2,3,4,5];
console.log(arr.each(function(element){
  console.log(element * 2)
}))
////////////////////////////////////////
Array.prototype.map = function(func) {
  var mapped_array = [];

  this.each(function(element) {
    mapped_array.push(func(element));
  })

  return mapped_array;
}

var arr = [1,2,3,4,5];

console.log(arr.map(function(el) {
  return el * 2
}))
////////////////////////////////////////

Array.prototype.inject = function(func) {
  var result = this[0];

  this.slice(1).each(function(element) {
    result = func(result, element);
  })
  return result;
};

var arr = [1,2,3,4,5]
console.log(arr.inject(function(total, item) {
  return total + item;
}));