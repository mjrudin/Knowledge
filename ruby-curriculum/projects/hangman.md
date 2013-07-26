# Hangman

In this project, we write a program to play [Hangman][wiki-hangman].

You should have two modes. In the first mode, the computer player
should read in a [dictionary file][dictionary]. It should choose
a word randomly. Interaction should look something like so:

    Secret word: _____
    > h
    Secret word: h____
    > l
    Secret word: h_ll_
    > z
    Secret word: h_ll_

Next, write the program to let the user pick a word; they only need to
put in how long it is, not what the word is. The human player shouldn't
trust giving the word to the computer. The computer should,
using its dictionary, start guessing. The human should tell the
computer the positions (if any) where that letter occurs.

The computer should try to be smart and guess letters from words of
the right length, and which match the currently known letters. To do
this, first narrow the dictionary down to the set of possible words. A
fair strategy is to guess the most frequent letter in the subset of
possible words.

Make sure your game class (probably named `Hangman`) doesn't do too
much. You should have `HumanPlayer` and `ComputerPlayer` classes; they
should contain the logic both for (1) guessing letters and (2)
confirming guesses.

After you finish these two cases, refactor your code so that you can have computer vs computer or human vs human as well.

[wiki-hangman]: http://en.wikipedia.org/wiki/Hangman_(game)
[dictionary]: https://github.com/appacademy/ruby-curriculum/blob/master/dictionary.txt
