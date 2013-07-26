function Cat(name, owner) {
  this.name = name;
  this.owner = owner;
}

Cat.prototype.cute_statement = function() {
  return this.owner + " loves " + this.name;
};

var cat1 = new Cat("Phoebe", "Aaron");
var cat2 = new Cat("Gypsy", "Aaron");

console.log(cat1.cute_statement());
console.log(cat2.cute_statement());

Cat.prototype.cute_statement = function() {
  return "Everyone loves " + this.name;
};

Cat.prototype.meow = function() {
  return "meow";
};

cat1.meow = function() {
  return "purr"
};