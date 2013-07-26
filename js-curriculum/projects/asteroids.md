# Asteroids

## Phase I: moving pieces (& asteroids)

### `MovingObject`

* Start out with a `MovingObject` class. 
* It should initialize with a position
* It should have an `#update` method that takes a velocity 
  (e.g. `{x: 3, y: -4}`) and updates the position accordingly
* It should have an `#offScreen` method that checks to see whether
  the object is off the screen

### `Asteroid`

* Make an `Asteroid` class that inherits from `MovingObject` (make
  sure to get the prototype chain right)
* `Asteroid` should initialize with a position
* Add a `Game` class. As part of construction it should initialize an
  `asteroids` property filled with randomly positioned `Asteroid`s.
    * You can create a `Asteroid.randomAsteroid` helper.
* Your `Game` class should be passed a canvas context on
  construction. It should have a `draw` method, which should in turn
  call `Asteroid`'s `draw` method.
    * The `Asteroid#draw` method should use canvas context methods
      like `fillStyle`, `arc`, and `fill`.
* Add a game loop. `Game#update` should call `Asteroid#update` on each
  `Asteroid`. `Game#start` should kick off the loop with
  `setInterval`. Each interval you should call `Game#update` followed
  by `Game#draw`. For smooth scrolling, set the timer to fire 32x per
  sec.
    * Your `Game#draw` needs to clear the canvas at the start of each
      turn to prepare for this turn's drawing.
    * You should use `ctx.clearRect(0, 0, width, height)` (where you
      need to find width and height).
* You should watch for asteroids that slip off the edge. They
  should be removed from `game.asteroids` when this happens.

## Phase II: ship and collision detection

* Add a `Ship` class. It should also inherit from `MovingObject`. 
* On construction, the game should initialize a `ship` property with a
  ship. Start it out in the center of the game map.
* Add a `Ship#draw` method and draw the ship in `Game#draw`.
* Add a `Ship#isHit` method; it needs to check whether it is hit by
  any asteroids.
    * To get the distance between two points, see
      http://en.wikipedia.org/wiki/Distance
    * If the distance is less than the sum of the ship and asteroid
      radii, they intersect.
    * You must either give the ship object a reference to the asteroids
      array or pass the array (or an array of positions) to the ship's
      `#isHit` method
* Call `#isHit` in the `Game#update` method; if so, alert user of game
  over and stop the timer.

## Phase III: moving the ship
* Your `Ship` should have a velocity attribute. It should start at `{
  x: 0, y: 0 }`.
* As with the `Asteroid` class, you should have a `Ship#update` method
  and call it from `Game#update`.
* To test things are working, hard-code it to have a non-zero velocity
  to start.
* You need to add key bindings now. Use the keymaster library. Bind 
  key handlers that trigger a method `Ship#power` which adjusts the
  velocity. `ship.power(dx, dy)` changes the velocity by `(dx, dy)`.
* Make sure you have a way to deal with the ship slipping off the screen.

## Phase IV: firing bullets
* Add a `Bullet` class. A `Bullet` has a direction. It should also
  inherit from `MovingObject`
* Add a `#draw` method. Give your bullet a (fast) fixed
  speed. To calculate velocity from direction and speed, multiply the
  direction by the speed. (You can tweak the math later).
* Add a `Ship#fireBullet` method. This should create a `Bullet`,
  giving it the initial position of the ship and the current direction
  of the ship's velocity.
    * You can calculate direction from velocity as `velocity /
      speed`. You can calculate speed as `sqrt(v.x ** 2 + v.y ** 2)`.
* Your `Bullet` constructor should take the `Game` object. On
  construction, it should add itself to a `game.bullets` array.  Like
  `Asteroid` objects, we should call `Bullet#draw` and `Bullet#update`
  from the `Game`'s version of those methods.
* You should now be able to fire bullets that don't actually shoot
  anything.
* The last step is to, on each call to `Bullet#update`, check if the
  bullet intersects with any asteroid. If so, remove them from the
  `Game.asteroids` and the `Game.bullets` arrays (your `Game` play loop
  can do this).
* Make sure to remove your bullets once they are off-screen. Otherwise
  you'll be keeping track of bullets that are already off-screen,
  wasting CPU cycles checking for collisions with asteroids.

## Bonus: Drawing an image

Oftentimes people want to draw a background image on their game.

```javascript
var img = new Image();
img.onload = function () {
  ctx.drawImage(img, xOffset, yOffset);
};
img.src = 'myImage.png';
```

Note you may have to redraw the background each iteration. You do not
need to constantly reload the img; just make sure to `ctx.drawImage`
each frame.

## Resources

* [Canvas tutorial](https://developer.mozilla.org/en-US/docs/HTML/Canvas/Tutorial?redirectlocale=en-US&redirectslug=Canvas_tutorial)
* [Canvas docs](https://developer.mozilla.org/en-US/docs/HTML/Canvas)

