# Paypal Presentation

## Introduction (~5min)

* Edward Ruggeri
* Worked at Quantcast and Google as software engineer
* Worked on big data teams, search infrastructure

## Many languages (~10min)

* Engineer productivity and flow are very important.
* Writing code is like writing text
* Engineers want a language that allows you to express your ideas
  clearly.
* Engineers also want to avoid irrelevant problems: Ruby gets out of
  your way by taking care of low-level details (memory management,
  especially).
* Many trade-offs in choosing which langauge to use:
    * Performance (Java and C++ are best)
    * Difficulty (Ruby is maybe the easiest, Java easy, C++ harder)
    * Available talent
* Specialization
    * Android apps are Java
    * iOS is Objective-C
    * Rails is a very popular Ruby web framework
    * JavaScript is for code that runs inside the web-browser

## Components of a web application (~30min)

* Web sites are from the 1990s, you have a **web service**.
    * The API (more in a second!) is the service.
    * www.paypal.com is the **web application**.
* A web application consists of several main components:
* A **database**, which is where the data lives. For instance,
  user account information, customer transactions, etc.
* Databases are the **SQL** (structured query language) part.
* The database just stores the information; this is the
  **backend**. To present the data to the user and allow the user to
  interact with it, we need to write **application code**. This runs
  in a **web server**.
* When a user types `paypal.com` into their web browser, it calls up a
  server at PayPal. The server requests data from the database (in the
  form of **SQL queries**), injects this into a HTML template, and
  then sends it back to the user.
* Web applications are **dynamic**. When a web application user
  requests his/her transactions, the server fetches just the correct
  transactions for this specific user.
* The browser than displays the page. JavaScript code may also execute
  in the browser: this is called the **front-end**.
* Example: on ebay.com you click a thumbnail and it switches the
  master image.
* Requests don't need to come directly from a web browser. Web servers
  respond to HTTP (hypertext transfer protocol) requests.
* Engineers define what the valid **requests** are (and the format of
  the **response**). This is the **API** (application programming
  interface).
* Partners pay for access to the API, which allows them to use the
  PayPal service as a component of their own web applications.

## Introduction to programming

* http://repl.it/languages/Ruby
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

### Examples

* `hello_world`
* `silly_sum`
* `num_squares` (number of squares < max)
* `max_subsum`
* `censor`

## Exercises

* **10min break**
* Please work in pairs of two.
* Write a method `years_to_seconds`
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
* Write a method `letter_count`
    * use the `String#split` method to split a string
    * Pass in the character to split on: splitting on `""` means split
      every character.
    * Iterate one-by-one through the letters, counting up the total
      amount.
* Write a method, `ordered_vowel_word?` that takes a string and
  returns true if the vowels occur in alphabetical order.
* Write a method `morse_encode` that translates a string to morse
  code. Use this helpful hash:

```ruby
MORSE_CODE = {
  "a" => ".-",
  "b" => "-...",
  "c" => "-.-.",
  "d" => "-..",
  "e" => ".",
  "f" => "..-.",
  "g" => "--.",
  "h" => "....",
  "i" => "..",
  "j" => ".---",
  "k" => "-.-",
  "l" => ".-..",
  "m" => "--",
  "n" => "-.",
  "o" => "---",
  "p" => ".--.",
  "q" => "--.-",
  "r" => ".-.",
  "s" => "...",
  "t" => "-",
  "u" => "..-",
  "v" => "...-",
  "w" => ".--",
  "x" => "-..-",
  "y" => "-.--",
  "z" => "--.."
}
```

* Write a method `anagrams(str, words)`.
    * It takes in a string and an array of words.
    * Your job is to find all the anagrams of `str`.
    * You may use your `letter_count` method here!
* Write `bubble_sort` to sort an array
    * Iterate through an array, comparing adjacent elements
    * If a pair is out of order, swap them
    * Continue making passes through the array until it is in sorted
      order.

## Bonus problems

* Simple `hangman` game.
* towers of hanoi
* Eight queens


### `encode`

Write a method named `encode(str)` which takes in a string and
returns an array of pairs: each pair contains the next distinct
letter in the string, and the number consecutive repeats.

    encode("aaabbcbbaaa") ==
      [["a", 3], ["b", 2], ["c", 1], ["b", 2], ["a", 3]]
    encode("aaaaaaaaaa") == [["a", 10]]
    encode("") == []

**Be careful!** You don't just want the overall count of each
letter: `encode("aaabbcbbaaa") != [["a", 6], ["b", 4], ["c",
1]]`. So make sure to count **consecutive** letters, not their
overall count.

Lastly, a common error is to forget to encode the last
tokens. Make sure that `encode("aabbcc") == [["a", 2], ["b", 2],
["c", 2]]`, **not** `[["a", 2], ["b", 2]]`.

### `nearby_words`

Write a method named `nearby_words(str, word_list)` which takes in
a string and an array of valid words (the word\_list).  It should
return an array of words from the word_list which are the same
except for a single letter at a single position.

For instance, "boot" and "boom" are nearby (differ in 4th letter),
but "loot" and "tool" are not (differ in first and fourth
letters). Note that position matters.

Here's an example of the method:

    WORDS = ["door", "moot", "boot", "boots"]
    nearby_words("moor", WORDS) == ["door", "moot"]

You may assume that the input string and word list contain
only lower case letters.

## Details

Where: PayPal/eBay Campus - 2211 N First Street, San Jose, CA. Please
call me when you arrive so I can meet you at security to get you a
badge.  312.297.1425

Session Time: 9am-12pm. Please arrive around 8am/8:15am so we can make
sure everything is set up properly.
