# Intro to Callbacks: File I/O

## What is a callback?

Closures are a very big part of Ruby. One reason they are so important
is because they are often used as **callbacks**.

A callback is a function that is passed to another function and
intended to be called at a later time. The most common use of
callbacks is when a result will not be immediately available,
typically because it relies on user input.

Perhaps the simplest example is to ask JavaScript to wait a specified
period of time and then call a function. This uses the `setTimeout`
method:

```javascript
// wait 2000 milliseconds and then print great movie link:
window.setTimeout(
  function () {
    console.log("http://en.wikipedia.org/wiki/Out_of_Time_(2003_film)");
  }, 2000
);
```

Here the callback prints the movie title. The `setTimeout` method
holds on to the function, waiting to call it after the appropriate
period. The callback is essential here, because `setTimeout` needs to
know what do at the end of the timeout.

The above function passes a *callback* to `setTimeout`, but this
function is not a *closure*, since it uses no outside
variables. That's because we've hard-coded the URL. Let's see an
example that illustrates why closures are so commonly used as
callbacks:

```javascript
function greatMovieReminder(movie) {
  // remind in one min
  window.setTimeout(function () {
      console.log("Remember to watch: " + movie);
    }, 60 * 1000
  );
}

greatMovieReminder("Citizen Kane");
greatMovieReminder("Touch of Evil");
greatMovieReminder("The Third Man");

// Easter egg!
// http://en.wikipedia.org/wiki/Frozen_Peas
```

## JavaScript is Asynchronous

In Ruby programming, most of the methods we wrote are **not** like
`setTimeout`. `setTimeout` sets a timer and then immediately
returns. `setTimeout` returns before the timeout is up, long before
the callback is actually invoked.

`setTimeout` is called *asynchronous*. An asynchronous function does
not wait for work to be completed. It schedules work to be
done. Asynchronous functions tend to be used when work may take an
indeterminate amount of time:

* timers
    * waits a user-specified amount of time
* background web requests (AJAX)
    * makes a possibly slow connection to a server that may live far away
* events
    * Example: there's a button on the page. We want to run a function
      when the user clicks it.
    * This is called a *click event*.
    * Function that installs a *click handler* (callback to invoke
      when click occurs) doesn't know how long it will be before the
      click happens.

The opposite of asynchronous is *synchronous*. For example, a
synchronous analogue to `setTimer` would be `sleep`, which would pause
execution for a specified period of time. Likewise, if AJAX requests
were not asynchronous, calls to `$.ajax` would not return right away,
but would instead wait for the HTTP response. The response could then
be returned to the caller, so no callback would be necessary.

## Node I/O is Async

Ruby has the methods `puts` and `gets`. JavaScript has `console.log`
as an analogoue to `puts`, but it doesn't have an exact analogue for
`gets`.

In a web browser, you may use the `prompt` method to pop up a message
box to ask for input from the user. When running server-side code in
the node.js environment, `prompt` is not available.

Instead, you must use the `readline` library when writing server-side
node.js programs. Here's the [documentation][readline-doc].

Here's a simple example:

```javascript
var readline = require('readline');

var reader = readline.createInterface({
  // it's okay if this part is magic; it just says that we want to 
  // 1. output the prompt to the standard output (console)
  // 2. read input from the standard input (again, console)

  input: process.stdin,
  output: process.stdout
});

reader.question("What is your name?", function (answer) {
  console.log("Hello " + answer + "!");
});

console.log("Last program line");
```

The `question` method takes a prompt (`"What is your name?"`) and a
callback. It will print the prompt, and then ask node.js to read a
line from stdin. `question` is asynchronous; it will not wait for the
input to be read, it returns immediately. When node.js has received
the input from the user, it will call the callback we passed to
`reader.question`.

Let's see this in action:

```
~/jquery-demo$ node test.js
What is your name?
Last program line
Ned
Hello Ned!
```

Notice that because `reader.question` returns immediately and does not
wait, it prints "Last program line" before I get a chance to write
anything. Notice also that I don't try to save or use the return value
of `reader.question`: that's because this method does not return
anything. `reader.question` cannot return the input, because the
function returns before I have actual typed any input
in. **Asynchronous functions do not return meaningful values: we give
them a callback so that the result of the async operation can be
communicated back to us**.

One final note: note that our program didn't end when it hits the end
of the code. It patiently waited for our input. That's because node
understands that there is an outstanding request for user input. node
knows that the program may not be done yet: anything could happen in
response to that input. So for that reason, node doesn't terminate the
program just because we hit the end of the source file.

## Example #1

Let's see a more developed example:

```javascript
var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function addTwoNumbers(callback) {
  // notice how nowhere do I return anything here! You never return in
  // async code. Since the caller will not wait for the result, you
  // can't return anything to them.
  
  reader.question("Enter #1", function (numString1) {
    reader.question("Enter #2", function (numString2) {
      var num1 = parseInt(numString1);
      var num2 = parseInt(numString2);

      callback(num1 + num2);
    });
  });
}

addTwoNumbers(function (result) {
  console.log("The result is: " + result);
});
```

Notice the use of closures and callbacks:

0. the `numString1` callback closure captures the callback.
0. the `numString2` callback closure captures `numString1`, and also the
   `callback`.
0. the `result` callback isn't a closure, as it captures nothing
   (result is passed as an argument.

## Example #2

Let's write a silly method, called `crazyTimes`:

```javascript
function crazyTimes(numTimes, fun) {
  var i = 0;
  
  function loopStep() {
    if (i == numTimes) {
      // we're done, stop looping
      return;
    } else {
      fun();

      // recursively call loopStep
      i += 1;
      loopStep();
    }
  }
  
  loopStep();
}
```

Notice how this loops in a weird way. Of course, this is a crazy way
to implement `times`, and you wouldn't do this normally. But we're
going to build on this in a moment...

## Example #3

When we need to do a loop in code that is asynchronous, we can modify
the trick from above:

```javascript
function buildArray(numberOfElements, callback) {
  var arr = [];

  function performStep() {
    if (arr.length === numberOfElements) {
      callback(arr);
      
      // we're done, stop looping
      return;
    }

    reader.question("Next element to add: ", function (element) {
      arr.push(element);

      // keep on looping!
      performStep();
    });
  }

  performStep();
}
```

## Exercises

### Timing is Everything

Use [`setInterval`][setInterval-doc] to build a small clock in your
terminal. It should every 5 seconds, display the current
time. However, you can only use `Date.now` once at the very beginning
of your program. Store the hour, minutes, and seconds. Your clock
should increment those variables over time. It should display the time
with the format HH:MM:SS.

### Crazy Sort

In this exercise, we write a method called
`crazyBubbleSort(callback)`. This should take an array, and then for
each comparison needed, prompt the user to ask which of two items is
bigger.

First, write a method `compare(el1, el2, callback)` which prompts the
user to compare two objects and then invokes the callback, passing
`-1` for `<`, `0` for `=`, or `1` for `>`.

Great! Next, we want to start performing iterations of the
algorithm. Write a method, `performSortPass(arr, callback)` which:

* loops through the array,
* asks the user to compare adjacent elements,
* swaps the elements if they are out of order.

Adopt the looping trick from above.

Once you have this working, it should be simple to write a final
function, `crazyBubbleSort(callback)`, which just repeatedly calls
`performSortPass` until the array is sorted.

[setInterval-doc]: http://nodejs.org/api/globals.html#globals_setinterval_cb_ms
