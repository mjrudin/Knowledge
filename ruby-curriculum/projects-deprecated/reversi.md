# Reversi TDD

## Reversi TDD: Part I
* Write the [Reversi][reversi] game TDD.
* You probably want a `Board`, `Piece`, `Game`.
* Do it TDD; that means writing the tests before the code.
* Do not write any user interaction code yet. Your `Game` should have a
  method `place_piece(position, color)`.
    * In particular, don't add a run loop yet.
* A challenge is to write your code in a way that is *testable*.
* Make sure to break up your code into different source files.
    * Make sure to break up your specs into different files.
    * Rip off my [Rakefile][rakefile].
    * Split up your code into lib/spec dirs.

[reversi]: http://en.wikipedia.org/wiki/Reversi
[rakefile]: https://github.com/appacademy/solutions/blob/master/w3/w3d1-w3d2/Rakefile

## Reversi TDD: Part II
* Begin writing a run-loop.
* `Game` should be modified to support `HumanPlayer`s and `AIPlayer`s.
* The `Game` run-loop tests should use `double`s to stand in for players.
* You don't need to test `HumanPlayer`; all it does is UI, and it is not
  typical to test UI.
* You should test `AIPlayer`. `AIPlayer` should have very simple logic:
  it should try to flip-over as many pieces as possible.
    * Ideally, you would isolate `AIPlayer` tests from the `Board`
      implementation by using a `double`.
    * Start out constructing a real `Board` object for your tests.
    * Later, switch out the real `Board` for a `double`.
