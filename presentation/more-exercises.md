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
