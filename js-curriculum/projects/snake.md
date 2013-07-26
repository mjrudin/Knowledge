# Snake

## Description

Implement a snake game. First write it entirely server-side. Write
Snake and Board objects. Add Snake methods to turn, and a Game method
that performs one "step" of the game. Each step should move the snake
and check for wall (or self) collisions.

You should be able to run it from the node console. I envision a test like:

    snake.turn("south");
    game.step();
    game.step();
    snake.turn("north");

When you have this down, start bringing your game to the browser. You
should write a separate file (snakeUI.js) that will handle user
input; **do not mix up UI into your snake library**. You should render
your game into a pre. You'll need a way to listen for user input
(left, right, up, down). To detect a keypress:

    $('html').keydown(function (event) {
      console.log("You pressed keycode: " + event.keyCode);
    });

Check out the [jQuery documentation][keydown-doc]. You'll need a "run
loop".  But in JavaScript, you can never have a proper run loop,
because the browser is single threaded and won't be able to read user
input or do anything else when you're stuck in a loop. Instead, you
can imitate a loop with [`setInterval`][setInterval-doc]

```javascript
function run_loop() {
  // this is called every 250millis
}

// kick off run loop in 250millis
STEP_TIME_MILLIS = 250;
window.setInterval(run_step, STEP_TIME_MILLIS);
```

[keydown-doc]: http://api.jquery.com/keydown/
[setInterval-doc]: https://developer.mozilla.org/en-US/docs/DOM/window.setTimeout

## Phase II: Graphical snake

To start, we've rendered an ASCII representation of your Snake game
into a `pre` element.

Let's make our Snake game graphical. Create a series of `div`
elements: one for each position in the grid. Save the DOM elements in
a hash from (x, y)-position to `div`. Each turn, iterate through all
the positions. Add a CSS class of `apple` or `snake` as appropriate to
each of the `div`s. Write simple CSS rules to color the grid positions
appropriately.

## Extensions

Many of you will finish the basic functionality with time to spare. Here are
some fun things you can add: 

* Keep score (10 points for each apple eaten)
* Pause and restart game
* Leaderboard (keep high scores)
* Tron Snake: 2 player snake (use the 'wasd' keys for one and arrow keys for the other) 
  with both snakes running at the same time.

Feel free to come up with extensions of your own. Have fun with it (and show off
to your classmates)!

