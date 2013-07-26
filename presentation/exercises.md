# Introduction to programming

* http://repl.it/languages/Ruby

## Core concepts

* Hello world in Ruby
    * gets and puts
* Variables
    * Assignment
* Strings
    * Concatenation
* Methods
    * `def`
    * `return`
* Comparisons
    * `if`
    * `true` and `false`
* While loops
* Arrays
    * `#each`
* Hash
    * `#[]`
    * `#[]=`

## Examples

* `hello_world`
* `silly_sum`
* `num_squares` (number of squares < max)
* `max_subsum`

## Exercises

* Please work in pairs of two.
* Write a method `greeter`
    * Ask for the user's first and last name
    * Print out a message that greets the user
* Write a method `pow(base, exponent)` that calculates `base` to the
  `exponent` power.
* Write a method `sum(numbers)` that calculates the sum of an array of
  numbers.
* Write a method `number_guesser`.
    * The computer guesses a number between one and a hundred
    * It asks if this is low or high
    * Based on user input, will make a new guess
    * Stops when it has successfully guessed the number.
* Write a method `uniq(array)` that takes an array and returns an
  array with the duplicates removed.
* Write a method `is_prime?(number)` that returns `true` if a number
  is prime; `false` otherwise.
    * Write a method `divides_evenly?(divisor, number)` which returns
      `true` if `divisor` evenly divides `number`.
    * For `divides_evenly?`, you need to find if there is another
      number, `divisor2` such that `divisor * divisor2 == number`.
    * You may iterate from two up to `number - 1` to try to find
      `divisor2`.
    * To write `is_prime?`, use `divides_evenly?`. In a loop, test all
      numbers from 2 to `number - 1`.
* Using your `is_prime?` method, write a method `primes(max)` which
  returns all primes between 2 and `max` in an Array.
