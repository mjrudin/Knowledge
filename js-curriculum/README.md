# Intro to JavaScript

## w5d5
* [Codecademy JS Curriculum][codecademy-js]
    * Through Objects I.
* [jQuery Fundamentals: JavaScript Basics][jq-fundamentals-js-basics]
    * (just the one chapter)
* [Server-side JavaScript][server-side-js]
* [Object-oriented JavaScript][oo-js]
* **Project**: [Intro JavaScript problems][intro-javascript-problems.md]

[codecademy-js]: http://www.codecademy.com/tracks/javascript
[jq-fundamentals-js-basics]: http://jqfundamentals.com/chapter/javascript-basics
[server-side-js]: ./intro-js/server-side-javascript.md
[oo-js]: ./intro-js/object-oriented-js.md
[intro-javascript-problems.md]: ./intro-js/intro-javascript-problems.md

## w5d6-w5d7
* Finish [Codecademy JS Curriculum][codecademy-js].
* Read [Eloquent JavaScript][eloquent-javascript]
    * ch1-ch4
    * ch6
    * ch8
* Acquire and begin reading [Effective JavaScript][effective-js]
    * This is a great resource. Read it throughout w6-w7 and **finish it
      by start of w8**.
* In addition to w6d1 readings, begin w6d2 readings.

[eloquent-javascript]: http://eloquentjavascript.net/
[effective-js]: http://effectivejs.com/

## w6d1
* [Closures and Scope][closures]
* [Intro to Callbacks: File I/O][file-io]
* [`this` and that][this-and-that]
* [Organizing JS libs][organization]
* [Ways to Call a Function][function-calling]
* **Projects**: Towers of Hanoi, Tic-Tac-Toe
    * Write user interaction with node's `readline` library.

[closures]: ./intro-js/closures.md
[file-io]: ./intro-js/intro-to-callbacks.md
[this-and-that]: ./intro-js/this-and-that.md
[organization]: ./intro-js/organization.md
[function-calling]: ./intro-js/function-calling.md

## w6d2
* [`arguments`][arguments]
* [Prototypal Inheritance][prototypal-inheritance]
* [Client-side JavaScript][client-side-js]
* [Asynchronous Client-side Code][asynchronous-js]
* [Basic Canvas Drawing][basic-canvas-drawing]
* **Demo**: [Canvas Demo][canvas-demo]
    * **Be sure to read this the night before**
* **Project**: [Asteroids project][asteroids-project]

[arguments]: ./intro-js/arguments.md
[prototypal-inheritance]: ./intro-js/prototypal-inheritance.md
[client-side-js]: ./client-side-js/client-side-javascript.md
[asynchronous-js]: ./client-side-js/asynchronous-js.md

[basic-canvas-drawing]: http://joshondesign.com/p/books/canvasdeepdive/chapter01.html

[canvas-demo]: https://github.com/appacademy-demos/first-canvas-demo
[asteroids-project]: ./projects/asteroids.md

## w6d3

* [Intro to jQuery][jquery-intro]
* [jQuery Fundamentals][jquery-fundamentals]
    * Skip JS basics, namespaced events, jQuery effects, and deferreds
* [Codecademy: jQuery][codecademy-jquery] (through ch4)
* **Demo**: [First jQuery Demo][first-jQuery-demo]
* **Project**: Add UI to Towers of Hanoi, Tic-Tac-Toe
* **Solo Project**: [Snake][snake-project]

[jquery-fundamentals]: http://jqfundamentals.com/
[jquery-intro]: ./client-side-js/jQuery.md
[codecademy-jquery]: http://www.codecademy.com/tracks/jquery
[first-jQuery-demo]: https://github.com/appacademy-demos/firstJQueryDemo
[snake-project]: ./projects/snake.md

## w6d4
* [Basic AJAX][basic-ajax]
    * Also make sure to have read the jQuery Fundamentals chapter on
      AJAX.
    * Skip the deferreds part.
* [AJAX Remote Forms][ajax-remote-forms]
* [Underscore Templates][underscore-templates]
* [Bootstrapping data][bootstrapping-data]
* **Project**: [FirstAjaxProject][first-ajax-project]

[basic-ajax]: ./client-side-js/basic-ajax.md
[rails-remote]: ./client-side-js/rails-remote.md
[underscore-templates]: ./client-side-js/underscore-templates.md
[bootstrapping-data]: ./client-side-js/bootstrapping-data.md

[first-ajax-project]: https://github.com/appacademy-demos/AjaxDemo

## w6d5
* **TODO**: brief reading that they'll build:
    * Models
    * Views
    * Templates (with EJS)
    * Global namespacing (with Store?)
* **Project**: [Photo Tagger][photo-tagger]
    * **TODO**: Is this traditional SPA enough? I feel like tagging is
      more widget-like. Maybe Todos is better
    * **Project**: [Solo AJAX Project][solo-ajax-project]

[photo-tagger]: ./projects/photo-tagger.md
[solo-ajax-project]: ./projects/solo-ajax-project.md

## w6d6-w6d7
* **Tutorial**: [TodoApp: Whirlwind Intro to Backbone][backbone-whirlwind]
* [Backbone's `extend` method][backbone-extend]
    * **TODO**: write this!
* **Code Reading**: [todos.js][todos.js]
* **Additional Readings**: [Intro Backbone Readings][intro-backbone]
    * **TODO**: Write our own version of this?

[intro-backbone]: ./backbone/intro-backbone.md
[backbone-extend]: ./backbone/extend.md
[backbone-whirlwind]: ./backbone/whirlwind.md
[todos.js]: http://backbonejs.org/docs/todos.html

## w7d1
* Install the [backbone-on-rails gem][backbone-on-rails-gem].
    * Follow the instructions to install
    * For JavaScript install (don't use CoffeeScript, please!), run
      `rails generate backbone:install --javascript`.
* **Project**: [JournalApp][journal-app]

[backbone-on-rails-gem]: https://github.com/meleyal/backbone-on-rails
[journal-app]: ./projects/journal.md

## w7d2
* Read [Wine Cellar][wine-cellar] demos.
* Read portions of [Backbone on Rails][backbone-on-rails-book]
    * Chapter 3: Organization
    * Chapter 4: Rails Integration (skip Rails 3.0 & Jammit sections)
    * Chapter 5: Routers, Views, and Templates (pp. 35-49)
    * Chapter 6: Models and Collections (pp. 84-90)
    * **TODO**: Should we also recommend
        [Backbone Fundamentals][backbone-fundamentals]?
* [Backbone `listenTo`][listen-to]
* [Backbone.Relational][backbone-relational]
    * **TODO**: flesh out this reading.
* **Project**: [News reader][news-reader]

[wine-cellar]: http://coenraets.org/blog/2011/12/backbone-js-wine-cellar-tutorial-part-1-getting-started/
[backbone-on-rails-book]: https://learn.thoughtbot.com/products/1-backbone-js-on-rails
[backbone-fundamentals]: https://github.com/addyosmani/backbone-fundamentals

[listen-to]: ./backbone/listen-to.md
[backbone-relational]: ./backbone/relational.md
[news-reader]: ./projects/news-reader.md

## w7d3

* **Project**: [Gist clone][gist-clone]

[gist-clone]: ./projects/gist-clone.md

## TODO

### Backbone

* escape & get
* always save via collection
* use a top level collection?
* associations
    * backbone on rails discusses this
    * Override model parse
    * Or set a change:attributes method?
    * Just because we fetch this as part of a SHOW, how should we
      update?
    * Probably shouldn't do nested update, but just post...
* What about pagination?
* They build a typeahead.
* https://learn.thoughtbot.com/products/1-backbone-js-on-rails

### Rails AJAX day

* [Basic `form_for` and `button_to`][form-for]
* [`:remote => true`][rails-remote]

[form-for]: ./client-side-js/form-for.md
[ajax-remote-forms]: ./client-side-js/ajax-remote-forms.md

### Random
* [Backbone Docs Reading][backbone-docs-reading]
* [Code Reading: underscore][underscore-further-annotated]
* **Project**: [Store][store-project]

[backbone-docs-reading]: ./todo-readings/backbone-readings.md
[underscore-further-annotated]: ./todo-readings/underscore-further-annotated.js
[secret-share-js]: https://github.com/appacademy-demos/secret-share.js
[store-project]: ./projects/store.md
