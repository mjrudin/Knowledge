# Intro to server-side JS

JavaScript's genesis comes from the browser; it was designed by
Netscape to add dynamic code inside Netscape Navigator. JavaScript
code was traditionally run by the user's browser, not the server.

In this respect, it was used very differently than Ruby. Programmers
didn't write JavaScript scripts (there wasn't a `javascript
my_script.js` command like `ruby my_script.rb`), nor was there a REPL
(no `irb` or `pry`). There are other differences rooted in JS's
history as a browser language that can make it frustrating for general
use.

In recent years, there has been more interest in bringing JavaScript
to the server. Our first JS programs won't feature the web browser at
all; they'll be a repeat of our first Ruby scripts.

We will use [node.js][node-js], a server-side JavaScript framework.

## Macports Installation

If you have MacPorts, installing should be as easy as

    sudo port install nodejs

This gives us access to the node REPL:

```
~$ node
> console.log("Hello student!");
Hello student!
undefined
```

We'll also want to install the node package manager at the same time:

    sudo port install npm

This is like RubyGems, it's used to share node.js libraries. We'll
eventually use some fancy libraries.

## Executing scripts

We can run scripts in node.js with the greatest of ease:

```javascript
// script.js
for (var i = 0; i < 10; i++) {
  console.log("The greatest of ease!");
}
```

```
~$ node script.js
The greatest of ease!
The greatest of ease!
The greatest of ease!
The greatest of ease!
The greatest of ease!
The greatest of ease!
The greatest of ease!
The greatest of ease!
The greatest of ease!
The greatest of ease!
```

We can also enter an interactive debugger:

    node debug script.js

Read the debugger [documentation][node-debug-docs], of course. It's
especially easy to make mistakes in JavaScript, so be sure to always
write your code in a debug-able maner and get used to the debugger.

[node-js]: http://nodejs.org/
[node-debug-docs]: http://nodejs.org/api/debugger.html
