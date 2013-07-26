# Designing a Program

Below are some guidelines and strategies in developing programs.

## Data

Start with required data.

  * What state data do you need? How will you represent it?
  * Store required data in instance variables
  * Do the setup in `initialize` (and feel free to use helper methods)

## Pseudocode

It's often helpful to start out with comments & pseudocode.

  * It helps organize your thoughts and plans
  * It's easier to refactor comments than it is to refactor code
  * Then you can flesh your comments out into real code
  * Fantasy driven development: Write the code you wish was there
    * This is a great way to discover the abstractions you'll want to
      build

## Abstractions

  * Abstractions (whether in methods or classes) help us free up mental
    space: we don't have to worry anymore about how that method or
    object does its work; we just care that it does what it's supposed
    to do
  * Use well-named, single responsibility helper methods liberally
  * Higher-level (i.e. more abstract) single-responsibility methods can
    me composed of multiple lower-level (i.e. less abstract) helper
    methods
  * Classes can wrap up related data and behavior
  
## Play Loops

  * Games usually advance in turns until some "game over" condition is
    met
  * `play` method should contain main game loop
  * Loop should contain logic for each game "round"
  * `play` should be pretty abstract (i.e. call out to other well-named
    methods)

## UI & Logic

  * Keep UI & logic separate
  * How do you know you've done so properly?: Could you theoretically
    play your game entirely within `pry` without any I/O (no interaction
    with `STDIN` or `STDOUT`)? (You should be able to)
  * The only method that should probably be calling out to UI methods is
    your play loop (and it should call out to UI methods, not actually
    do any UI itself)

