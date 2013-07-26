# Ruby Library Management

Many of our projects have been contained in a single file, but
in real projects, programs are spread out across many files and
folders.

Ruby gives us three means by which to manage dependencies among
those files:

* `require`
* `require_relative`
* `load`

## Why?

```ruby
# lib/board.rb
class Board
  def initialize
    @grid = Array.new(10)
  end
end

# lib/game.rb
class Game
  def initialize
    @board = Board.new
  end
end

game = Game.new
```

```
$ ruby lib/game.rb
lib/game.rb:3:in `initialize': uninitialized constant Game::Board (NameError)
```

Ruby doesn't know what `Board` is (because it's defined in another
file) and so throws an error. The problem is that the `game.rb` file
does not tell Ruby that `board.rb` should be loaded:

Well, we know how to deal with this:

```
# lib/game.rb
require 'board'

class Game
  def initialize
    @board = Board.new
  end
end

game = Game.new
```

A simple `require 'board'` statement at the top of *game.rb* should do
the trick.

*in terminal*

```
$ ruby lib/game.rb
.../lib/ruby/site_ruby/1.9.1/rubygems/custom_require.rb:36:in `require':
cannot load such file -- board (LoadError)
```

Huh? I thought we knew how to solve this problem? Why did we receive a
`LoadError`?

A `LoadError` is basically telling you that Ruby did not find the file
that you told it to load. Why not; `board.rb` is in the same directory
as `game.rb`, after all...

This is not enough. The problem is Ruby's **load path**.

## Ruby's Load Path: `$LOAD_PATH`

Whenever you use a `require` statement, Ruby tries to find the
specified file in its **load path**, which is a list of
directories. Its specific purpose is to maintain the list of
directories through which Ruby will search when a `require` or `load`
statement is run by the interpreter.

The load path includes things like the files that make up Ruby's
Standard Library as well as gems you have installed. You can always
access it through the global variable `$LOAD_PATH`.

The directory `'.'` (i.e. the current directory) is not in the load
path. Funny enough, it used to be, but in Ruby 1.9.2, the
current directory was removed from the load path for security
reasons. Oh well.

So, what can we do?

We have three options:

0. Use an explicit path (like `./board`),
1. Use `require_relative`,
2. Or add a folder to the load path with the `-I` flag

## Explicit paths

Even if a file is not in a `$LOAD_PATH` directory, you can still load
it if you give an explicit path to the file. For instance, you can
write `require './board.rb'`, which will look for `board.rb` in the
current directory (`.`).

There is on problem: the current directory is **the directory you are
running ruby from**. So if you run:

    ruby lib/game.rb

`require './board.rb'` will look inside the current directory for
`board.rb`; which is outside `lib`.

To fix this problem, we often use `require_relative`.

## `require_relative`

`require_relative` is `require`'s sometimes more helpful brother.  It
does just what `require` does, but instead of looking up a file in the
load path, it will use the directory of the current source file as the
starting point:

```
# lib/game.rb
require_relative `board`

class Game
  def initialize
    @board = Board.new
  end
end

game = Game.new
```

*in terminal*

```
$ ruby lib/game.rb
```

Ah, wonderful. Everything worked without a hitch this time. Even
though we launched Ruby outside `lib`, since `game.rb` lives in `lib`,
it looked in `lib` for `board.rb`.

Note that it is superfluous to add `./` with `require_relative`. Also
note that neither `require` nor `require_relative` will force you to
use the standard `.rb`; they'll add it for you.

## Add a folder to the load path `-I`

Another option we have it to add the current directory to the load
path using the `-I` flag when we call the `ruby` or `irb` or `pry`
commands in the terminal.

```
# lib/game.rb
require `board`

class Game
  def initialize
    @board = Board.new
  end
end

game = Game.new
```

**NB: Note the regular `require` statement.** Then we write:

```
$ ruby -I lib lib/game.rb
$
```

Once again, everything goes off without a hitch.

What happened here?

The `-I` flag takes a single directory as an argument and
adds it to the load path. Here, I added `lib` to the load
path and so when the `require 'board'` statement was hit at the
top of the game file, the interpreter had no problem finding it.

The convention with the `-I` flag is actually to leave no space
between the flag and the folder and so you may see the flag used
like so (and you should use it this way too):

```
$ ruby -Ilib lib/game.rb
$ ruby -I. my_file.rb  # Adds the current dir to the path
$ pry -Ispec spec/file_spec.rb
```

In general, `-I` is a poor alternative to `require_relative`. `-I` is
typically used in other, stranger cases, where Ruby library code lives
off the default `$LOAD_PATH`, but outside the current project.

Use `require_relative` when your code wants to include other code you
wrote from the same project.

## `load`

Finally we come to `load`.

What's the difference between `load` and `require`?

With `require`, Ruby keeps a list of the files that have already
been required, and so if you require a file twice (for example,
in pry or irb), the second call to `require` will do nothing.
The Ruby interpreter will check to see if that file has previously
been required, see that it has, and do nothing.

`load` will read in the file every time no matter what. This can
be useful especially when working with a file in pry or irb.
You interact with it in pry, then go and change something in the
file. If you use `require` in pry each time, you won't actually
see the changes in your file reflected in pry because the
interpreter sees that the file has previously been required and
does nothing. But if you use `load`, the updated file will be read
in.

**Never use `load` in source files**. `load` should only be used in
the context of a REPL like pry or irb. There should never be a
necessity to use `load` in a source file, since source files will not
be dynamically modified and re-loaded during the duration of a
running, production program. `load` is there for convenience when
developing and debugging in the REPL.

*NB: `require_relative`, as was mentioned before, works in exactly
the same way as `require`.*
