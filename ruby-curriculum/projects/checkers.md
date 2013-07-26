# Checkers

* Don't focus on the `User` interaction first, focus on setting up the
  `Board` and getting `Piece` movement correct.
* A non-king `Piece` can move forward only; kings can move backward
  and forward.
* Probably don't need a `PawnPiece` and `KingPiece`; just "promote" a
  `Piece` to king when it hits the opposite row.
* You'll want `Piece` methods that list `#slide_moves` and
  `#jump_moves`.
* Write methods `perform_slide` and `perform_jump` that validate the
  move. `perform_jump` should remove the jumped piece from the
  `Board`.
    * An illegal slide/jump should raise an `InvalidMoveError`.
* Write a method `Piece#perform_moves!(move_sequence)` that takes a
  sequence of moves. This can either be one slide, or one or more
  jumps.
* `perform_moves!` should perform the moves one-by-one. If a move in
  the sequence fails, an `InvalidMoveError` should be raised.
    * `perform_moves!` should not bother to try to restore the
      original `Board` state if the move sequence fails.
* Write a `valid_move_seq?` that calls `perform_moves!` on a duped
  `Piece`/`Board`. If no error is raised, return true; else false.
    * This will of course require `begin`/`rescue`/`else`.
    * Because we dup the objects, `valid_move_seq?` should not modify
      the original `Board`.
* Write a `perform_moves` method that checks `valid_move_seq?`, and
  either calls `perform_moves!` or raises an `InvalidMoveError`.
