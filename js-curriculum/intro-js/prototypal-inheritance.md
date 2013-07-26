# Prototypal Inheritance

## Classes & Prototypes

JavaScript has an unusual system for implementing classes. This system
is called *prototypal inheritance*, and it differs from the *classical
inheritance* that we are familiar with from Ruby.

When you call any property on any JavaScript object, the interpreter
will first look for that property in the object itself; if it does not
find it there, it will look in the class's prototype (which is stored
in the object's internal `__proto__` property).

If it does not find the property in the prototype, it will recursively
look at the prototype's `__proto__` property to continue up the
*prototype chain*. How does the chain stop?
`Object.prototype.__proto__` is undefined, so if the prototype is not
an instance of a class (i.e., just a plain old `Object`), the chain
will end.

Inheritance in JavaScript is all about setting up the prototype
chain. Let's suppose we have `Animal`s and we'd like to have `Dog`s
and that inherit from `Animal` and `Poodle`s that inherit from `Dog`.

Well, we know that we'll instantiate each of these constructor style:

```javascript
function Animal () {};
function Dog () {};
function Poodle () {};

var myAnimal = new Animal();
var myDog = new Dog();
var myPoodle = new Poodle();
```

* `myAnimal`'s `__proto__` references `Animal.prototype`.
* `myDog`'s `__proto__` references `Dog.prototype`.
* `myPoodle`'s `__proto__` references `Poodle.prototype`.

Great, but `Animal`, `Dog`, and `Poodle` don't yet inherit from each
other. How can we link them up?

Well, we know that we want `Poodle.prototype` to reference
`Dog.prototype`, and we want `Dog.prototype` to reference
`Animal.prototype`. And when we say reference, we really mean that we
want the `__proto__` property to point to the correct prototype
object. In particular, we want:

* `Poodle.prototype.__proto__ == Dog.prototype`
* `Dog.prototype.__proto__ == Animal.prototype`

`__proto__` is a special property: you can't set it yourself. Only
JavaScript can set `__proto__`, and the only way to get it to do it is
through constructing an object with the `new` keyword.

So this is how we hook up the classes into a prototypal inheritance
chain:

```javascript
function Animal() {};

function Dog() {};
// Replace the default `Dog.prototype` completely!
Dog.prototype = new Animal();

function Poodle() {};
// Likewise with `Poodle.prototype`.
Poodle.prototype = new Dog();

var myAnimal = new Animal();
var myDog = new Dog();
var myPoodle = new Poodle();
```

*Voila.* Prototypal inheritance. 

Any property that is placed in `Animal.prototype` will be accessible
to all `Dog`s and `Poodle`s. And any property placed in
`Dog.prototype` will be accessible to `Poodle`s.

## Implementing classical class inheritance

Okay, you may have noticed something odd with these `prototype`s. In
setting up a prototype (say, set `Dog.prototype` to an `Animal`
instance), we construct an `Animal` instance.

Doesn't that seem weird? We create an `Animal` instance (to set up
`Dog.prototype`), before we instantiate any `Dog`s. Why? The `Animal`
object instance stored in `Dog.prototype` is sort of a "fake"
`Animal`; is it really right to create this? It doesn't feel right
that **defining** a new type of `Animal` should involve **constructing
an instance** of `Animal`.

One side-effect of this weirdness is that

0. the `Animal` constructor will be called before we create any `Dog`s
0. and creating a `Dog` instance will never run the `Animal`
   constructor.

Let's see:

```javascript
function Animal(name) {
  this.name = name;
};

Animal.prototype.sayHello = function () {
  console.log("Hello, my name is " + this.name);
};

function Dog() {};
// Hey wait, doesn't Animal need a name?
Dog.prototype = new Animal();

Dog.prototype.bark = function () {
  console.log("Bark!");
};

// We're not even going to run `Animal`'s constructor, so why bother
// passing the name?
var dog1 = new Dog("James");

// `this.name` is `undefined`
dog1.sayHello();
```

### The Surrogate Trick

Let's summarize our goals:

0. `Dog.prototype.__proto__` **must be** `Animal.prototype` so that we can
   call `Animal` methods on a `Dog` instance.
0. Constructing `Dog.prototype` **must not** involve calling the
   `Animal` constructor function.

The classic trick to accomplish this is to introduce a third class,
called the *surrogate*. Let's see the trick:

```javascript
function Animal(name) {
  this.name = name;
};

Animal.prototype.sayHello = function () {
  console.log("Hello, my name is " + this.name);
};

function Dog() {};

// The surrogate will be used to construct `Dog.prototype`.
function Surrogate() {};
// A `Surrogate` instance should delegate to `Animal`.
Surrogate.prototype = Animal.prototype;

// set `Dog.prototype` to a `Surrogate`
// instance. `Surrogate.__proto__` is `Animal.prototype`, but `new
// Surrogate` does not invoke the `Animal` constructor function.
Dog.prototype = new Surrogate();

Dog.prototype.bark = function () {
  console.log("Bark!");
};
```

This is better, because it avoids improperly creating an `Animal`
instance when setting `Dog.prototype`. However, we still have the
problem that `Animal` won't be called when constructing a `Dog`
instance.

Let's make one final tweak to the previous solution:

```javascript
function Dog(name, coatColor) {
  // call super-constructor function on **the current `Dog` instance**.
  Animal.call(this, name);

  // `Dog`-specific initialization
  this.coatColor = coatColor;
}
```

This pattern is especially useful if the superclass (`Animal`) has a
lot of initialization code. You could have copy-and-pasted the
`Animal` constructor code into `Dog`'s constructor, but calling the
`Animal` constructor itself is obviously much DRYer.

Last of all, please note the use of `Animal.call`. Inside the `Dog`
constructor, we don't want to construct a whole new `Animal`
object. We just want to run the `Animal` initialization logic **on the
current `Dog` instance**. That's why we use `call` to call the
`Animal` constructor, setting `this` to the `Dog` instance.

## Exercises

### `inherits`

In your Asteroids game, you set up prototypal inheritance. The downside was
that there was a lot of repeated code. 

**Exercise:** Write an `inherits` method on `Function.prototype` and also on
`myUnderscore` that will properly setup the inheritance chain.

Here's how it should be able to be used:

```javascript
function MovingObject() {};
function Ship () {};

Ship.inherits(MovingObject);

// OR

myUnderscore.inherits(Ship, MovingObject);
```

**Exercise:** Rewrite your `inherits` method so that it never calls the parent
constructor but still properly sets up the prototype chain. Also ensure that
your inherits method copies over all "class"-level properties of the parent 
constructor to the child constructor. 

**Exercise**: Go back to your Asteroids game and refactor it to use your new
`inherits` method.
