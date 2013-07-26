# Word Chains

Read the [RubyQuiz][quiz]. It may be down, in which case use the
WaybackMachine.

*NB: You don't have to use recursion for this one.*

The general idea is this:

* First, write a helper method `adjacent_words(word, dictionary)`.
* Write a method `find_chain(start_word, end_word, dictionary)`. It
  should:
* Start with the starting word, add it to a set called
  `current_words`.
* Grow a new set, `new_words`, by calling `adjacent_words` on each of
  the words in `current_words`.
* Be careful not to add any of the `current_words` to `new_words`. You
  can do this by also keeping track of a set, `visited_words`. Each
  time you encounter a new word, add it to `visited_words`.
* If you encounter the target word while building `new_words`,
  congratulations; there is a path to your target! If not, then you
  need to replace `current_words` with `new_words`, clear out
  `new_words` and regrow `new_words` (loop back around).
* It's important to not revisit words that you've been to already or
  else you'll get stuck in loops.

The advantage to this approach is that it visits all the words that
are adjacent to the starting word. Then you grow that set of words to
visit all the words that are two steps away. Then you visit all words
that are three steps away...

Okay, great. This will keep growing `new_words` until it hits the
target. But how to find the chain?

Instead of merely keeping track of a set of `visited_words`, keep
track of a hash: the key can be the new word, and the value can be the
word that we came from to first reach the new word. You can start this
out with `start_word` mapping to `nil`.

Write a method, `build_chain(visited_words, word)`. This should lookup
`word` in `visited_words` to find the prior word. Then lookup the
prior word. Then the word prior to that. Keep going back (collecting
the prior words in an array) until you hit `nil`. That means you
already collected the starting word, too.

Good luck!

## Dictionary File

[Click through][dictionary], hit the "RAW" button, and save the text
file. Don't just save-as; tha will save an HTML version of the github
page.

[quiz]: http://www.rubyquiz.com/quiz44.html
[dictionary]: ./dictionary.txt
