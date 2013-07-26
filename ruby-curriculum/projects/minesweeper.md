# Minesweeper

Everyone remembers [Minesweeper][minesweeper-wiki], right? Let's build it!

Support two grid sizes:

* 9x9 board with 10 mines
* 16x16 board with 40 mines (do this later, should be easy)

The user has two choices each turn.

### Reveal

First, they can choose a square to reveal. If it contains a bomb, game
over. Otherwise, it will be revealed. If none of its neighbors
contains a bomb, then all the adjacent neighbors are also revealed. If
any of the neighbors have no adjacent bombs, they too are revealed. Et
cetera.

The "fringe" of the revealed area are squares all adjacent to a
bomb. The fringe should be revealed, but should contain counts of how
many adjacent bombs are nearby.

### Flag bomb

The user may also flag a square as containing a bomb. The goal of the
game is to flag all the bombs correctly and reveal all the bomb-free
squares; at this point the game ends.

If a bomb is flagged incorrectly, it is not eligible to be revealed,
even if it otherwise would be.

### User interaction

You decide how to display the current game state to the user. I
recommend `*` for unexplored squares, `_` for "interior" squares when
exploring, and a one-digit number for "fringe" squares. I'd put an `F`
for flagged spots.

You decide how the user inputs their choice. I recommend a coordinate
system. Perhaps they should prefix their choice with either "r" for
reveal or "f" for flag.

### Saving

After you have your UI working, you should add save/load
functionality. You should be able to save/load your minesweeper game
to/from a file.

As a bonus, you may also wish to track the time it takes for the user
to solve the game, keeping track of the ten best times. You may want
to keep separate lists for the different sizes.

[minesweeper-wiki]: http://en.wikipedia.org/wiki/Minesweeper_(Windows)

[minesweeper-images]: https://www.google.com/search?q=minesweeper&hl=en&source=lnms&tbm=isch&sa=X&ei=-YpIUbm4Ne3OigLqtoCQCA&ved=0CAoQ_AUoAQ&biw=1440&bih=718#imgrc=oVJxrNO_45jh2M%3A%3BDpsumKp3yEhDPM%3Bhttp%253A%252F%252Fimgsrv.worldstart.com%252Fct-images%252Fminesweeper_cheat.jpg%3Bhttp%253A%252F%252Fwww.worldstart.com%252Fminesweeper-secret%252F%3B400%3B287
