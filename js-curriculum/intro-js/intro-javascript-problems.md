# Intro JS Exercises

## Constructors and Prototypes

* Define a `Cat` class
    * The constructor method should take a name and owner.
    * It should save these in attributes of the object.
    * Write a `Cat#cute_statement` method that returns "[owner] loves
      [name]".
    * `#cute_statement` should be defined on the prototype.
* Prototypes example:
    * Create several `Cat`s, test out their `cute_statement` method.
    * Reset the `Cat.prototype.cute_statement` method with a function
      that returns "everyone loves [name]!"
    * Run `Cat#cute_statement` on your old cats; the new method should
      be invoked.
* Add a `Cat#meow` method to the `Cat` prototype. You can now call
  `meow` on your previously constructed `Cat`s.
* Take one of your cats and set the `meow` property *on the instance*
  (`cat1.meow = function () { ... }`. Call `meow` on this `Cat`
  instance; call `meow` on any other cat. The other cats should
  continue to use the original method.

## Iteration exercises

Do the [Array exercises][array-exercises] in JS.

* dups
* two sum
* transpose

[array-exercises]: https://github.com/appacademy/ruby-curriculum/blob/master/language-basics/data-structures/array.md

## Enumerable exercises

Do the [Enumerable exercises][enumerable-exercises] in JS.

* multiples
* my_each
* my_map
   * it must use your 'my_each' function 
* inject
   * your inject should take a function
   * **it must also use your 'my_each' function**

[enumerable-exercises]: https://github.com/appacademy/ruby-curriculum/blob/master/language-basics/data-structures/enumerable.md

## Iteration exercises

Do the [iteration exercises][iteration-exercises] in JS.

* bubble sort
    * with your own sorting function
* substrings

[iteration-exercises]: https://github.com/appacademy/ruby-curriculum/blob/master/language-basics/iteration.md

## Recursion exercises

Do the [recursion exercises][recursion-exercises] in JS. Do them all
except deep_dup

[recursion-exercises]: https://github.com/appacademy/ruby-curriculum/blob/master/language-basics/recursion.md

## Prototype exercises

If you haven't already, go back and redo the relevant exercises by defining a method on the object's prototype
(i.e. define 'my_each' on the Array prototype, 'substrings' on the String prototype, etc.)
