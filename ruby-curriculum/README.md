# Intro Ruby Topics

## Meta

+ [Course Preliminaries][course-preliminaries]
+ [Daily requirements][daily-requirements]
+ [First day instructions][first-day-instructions]

[course-preliminaries]: https://github.com/appacademy/meta/blob/master/course-preliminaries.md
[daily-requirements]: https://github.com/appacademy/meta/blob/master/daily-requirements.md
[first-day-instructions]: https://github.com/appacademy/meta/blob/master/first-day-instructions.md

## Ruby basics
### w1d1
+ Tips/Tricks
    + [Keyboard Shortcuts][keyboard-shortcuts]
    + [A note on Ruby versions][versions]
+ Primitive Ruby types (common methods)
    + [Array][array]
    + [String][string]
    + [Hash][hash]
    + [Enumerable][enumerable]
    + [Object][object]
+ Debugging
    + [pry and debugger][pry-and-debugger]
    + [common error messages][common-error-messages]
+ Running/loading Ruby code
    + [Source files][source-files]
    + [Writing a Ruby Script][writing-a-script]
+ **Project**: In Words (ex #15) from [Test First Ruby][test-first-ruby]
+ **Bonus project**: [Maze solver][maze-project]
+ **Bonus project**: Use Ruby to solve the
  [eight-queens problem][eight-queens].

[keyboard-shortcuts]: ./w1d1/shortcuts.md
[versions]: ./w1d1/versions.md

[array]: ./w1d1/data-structures/array.md
[string]: ./w1d1/data-structures/string.md
[hash]: ./w1d1/data-structures/hash.md
[enumerable]: ./w1d1/data-structures/enumerable.md
[object]: ./w1d1/data-structures/object.md

[pry-and-debugger]: ./w1d1/debugging/debugger.md
[common-error-messages]: ./w1d1/debugging/common-exceptions.md

[source-files]: ./w1d1/running-ruby-code/source-files.md
[writing-a-script]: ./w1d1/running-ruby-code/writing-a-script.md

[test-first-ruby]: https://github.com/alexch/learn_ruby
[maze-project]: ./projects/maze-solver.md
[eight-queens]: http://en.wikipedia.org/wiki/Eight_queens_puzzle

### w1d2
+ [Methods][methods]
+ [Iteration][iteration]
+ [Symbols, Strings, and Option Hashes][symbols-and-strings]
+ [Input/Output][input-output]
+ Style
    + [DRY: Don't Repeat Yourself][dry]
    + [Coding style][coding-style]
    + [Method decomposition][method-decomposition]
    + [Choosing good names][naming]
+ [Classes][classes]
+ [Pass by reference][pass-by-reference]
+ **Project**: [MicroBlogger][microblogger]
  * Don't do the Klout part.

[methods]: ./w1d2/methods.md
[iteration]: ./w1d2/iteration.md
[symbols-and-strings]: ./w1d2/symbols-and-strings.md
[input-output]: ./w1d2/io.md

[dry]: ./w1d2/style/dry.md
[coding-style]: ./w1d2/style/coding-style.md
[method-decomposition]: ./w1d2/style/method-decomposition.md
[naming]: ./w1d2/style/naming.md

[classes]: ./w1d2/classes.md
[pass-by-reference]: ./w1d2/pass-by-reference.md

[microblogger]: http://tutorials.jumpstartlab.com/projects/microblogger.html

## Basic design

### w1d3
+ [Designing a Program][program-design]
+ [Refactoring and Code Smells][code-smells]
+ [Scope][scope]
+ **Project**: [Mastermind][mastermind]
+ **Project**: [Hangman][hangman]

[program-design]: ./w1d3/designing-a-program.md
[code-smells]: ./w1d3/refactoring.md
[scope]: ./w1d3/scope.md

[mastermind]: ./projects/mastermind.md
[hangman]: ./projects/hangman.md

## Algorithms

### w1d4
+ [Blocks][blocks]
+ [Recursion][recursion]
+ **Project**: [Word chains][word-chains]
+ **Project**: [Test First Ruby][test-first-ruby] XML parser (use [method_missing][method_missing])

[blocks]: ./w1d4/blocks.md
[recursion]: ./w1d4/recursion.md

[word-chains]:  ./projects/word-chains.md
[test-first-ruby]: https://github.com/alexch/learn_ruby
[method_missing]: ./language-intermediate/reflection.md#method_missing

### w1d5
+ [Intro data structures][intro-data-structures]
+ **Project**: [Knight's Travails][knights-travails]
+ **Project**: [Tic-Tac-Toe AI][tic-tac-toe-ai]

[intro-data-structures]: ./w1d5/intro-algorithms.md

[knights-travails]: ./projects/knights_travails.md
[tic-tac-toe-ai]: ./projects/tic-tac-toe-ai.md

## Git
### w1d6-w1d7
+ [git](https://github.com/appacademy/ruby-curriculum/blob/master/git.md)
+ **Project**: [Git immersion](http://gitimmersion.com/)
+ **Project**: Do Hangman and Word chains again, using git this
  time. Do not refer to your old code.
+ Assessment Prep

## Language Basics II, OO Design
### w2d1
+ [Serialization][serialization] (JSON and YAML)
+ [Gems and rvm][gems]
+ **Project**: [Minesweeper][minesweeper]
    * Use git. Here's a [git summary][git-summary].

[serialization]: ./w2d1/serialization.md
[gems]: ./w2d1/gems-and-rvm.md

[minesweeper]: ./projects/minesweeper.md
[git-summary]: ./git-summary.md

### w2d2
+ [Class inheritance][inheritance]
+ [Exceptions, error handling][errors]
+ [Decomposition into objects][object-decomposition]
+ [Inheritance, Polymorphism and DRY][inheritance-design]
+ [Information hiding/encapsulation][hiding]
+ **Project**: [Chess][chess]

[inheritance]: ./w2d2/inheritance.md
[errors]: ./w2d2/errors.md
[object-decomposition]: ./w2d2/object-decomposition.md
[inheritance-design]: ./w2d2/inheritance-design.md
[hiding]: ./w2d2/hiding.md

[chess]: ./projects/chess.md

### w2d3
* Continue Chess.

### w2d4
* Read [Chess solution][chess-solution] side-by-side with
  your own code
* **Solo Project**: [Checkers][checkers-project]

[chess-solution]: https://github.com/appacademy/solutions/tree/master/w2/w2d2-w2d3/lib
[checkers-project]: ./projects/checkers.md

## RSpec
### w2d5
+ [Introduction to RSpec][intro-rspec]
+ [RSpec Syntax][rspec-syntax]
+ [TDD][intro-tdd]
+ [Test doubles][test-doubles]
+ [`subject` and `let`][subject-and-let]
+ [guard-rspec][guard-rspec]
+ **Demo Reading**: read assessment00 and assessment01 spec files
+ **Project**: [First TDD Projects][first-tdd-projects]
+ **Solo Project**: [Poker][poker-project]

[intro-rspec]: ./w2d5/intro-rspec.md
[rspec-syntax]: ./w2d5/rspec-syntax.md
[intro-tdd]: ./w2d5/intro-tdd.md
[test-doubles]: ./w2d5/test-doubles.md
[subject-and-let]: ./w2d5/subject-and-let.md
[guard-rspec]: ./w2d5/guard-rspec.md

[first-tdd-projects]: ./projects/first-tdd-projects.md
[poker-project]: ./projects/poker.md

### w2d6-w2d7
+ Finish [Poker][poker-project]
+ Begin [SQL Curriculum W3D1][sql-curriculum] readings.

[sql-curriculum]: https://github.com/appacademy/sql-curriculum

## Additional Bonus Topics
+ [Modules][modules]
+ [Metaprogramming and Reflection][metaprogramming]
+ [load/require/require_relative][require]
+ **TODO**: [public/private/protected][privacy]
+ **TODO**: Class and instance variables
+ **TODO**: Hash and the various equal methods

[modules]: ./bonus/modules.md
[metaprogramming]: ./bonus/metaprogramming.md
[require]: ./bonus/require.md
[privacy]: ./bonus/privacy.md
