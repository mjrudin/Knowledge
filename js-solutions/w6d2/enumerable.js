// multiples
function multiply(nums) {
  var multiplied = [];

  for (var i = 0; i < multiplied.length; i++) {
    multiplied.push(this[i] * 2);
  }

  return multiplied;
}

// my each
Array.prototype.myEach = function(func) {
  for (var i = 0; i < this.length; i++) {
    func(this[i]);
  }

  return this;
};

// inject
Array.prototype.inject = function(element, func) {
  var injected = [];

  for (var i = 0; i < this.length; i++) {
    injected.push(func(element, this[i]));
  }

  return injected;
};