# Photo Tagger

Today, you'll be building a full-stack application that will enable a
user to add a photo and tag the user's friends in that photo. You'll be
dealing with multiple users, multiple photos, and multiple tags at once.

Read through the whole project first to get a sense of what you'll be
building and how everything ties together.

## Functionality Overview

### Photos Index Page

A user will login. Upon login, they will be redirected to the photo
index page where they will see all the photos they have previously
added. On the index page, there should be a form to add a new photo. It
should simply take a URL to that photo. When the user clicks on a photo
it should take them to the photo show page.

Everything but login should be AJAX. No page refreshes. (And if you're
feeling pretty good, go ahead and make login AJAX as well - and make
sure it works). 

### Photo Show Page (i.e. tagging page)

When a user is at a photos show page, the photo should be enlarged and
centered on the page. The user should be able to click anywhere on the
photo and see a dropdown of the user's friends. Upon clicking one of the
names, the tag should be saved and rendered onto the page.

## Phase I: Rails API

You may want to first get login functionality setup, then proceed with
the rest.

### Models

Start by building the requisite models with relevant associations and
validations.

Users have friends and photos, tags belong to photos and are always of a
friend, photos have tags. Let it flow through your fingers into code.

### API Layer

When thinking about the API layer, don't start with the controllers.
Start with your routes. Think about all the data needs of your
application and which routes will serve which needs. Think about
sensible nesting. In the next phase, your JavaScript models will be
interacting with these routes - those models are the consumers of the
routes your write.

Then write your controllers to respond with JSON. Make it so that the
only route that responds to both HTML and JSON is your photos index
route.

## Phase II: JavaScript Models

*NB: All of your JavaScript code today should go in the
`app/assets/javascripts` folder. For this section, create a folder
called `models` and put your JavaScript models in there, one per file.
Don't forget that you're only allowed one global variable. Choose
wisely.*

Just for today, don't bootstrap any data. We're going to focus on the
data communication layer for this phase. The first step in JavaScript
code organization will be to abstract out the data layer into JavaScript
models. Once you have this setup, the rest of your JavaScript
application should never deal with raw data (JSON objects) or make AJAX
requests to the server - it will only interact with your models.

### Model Responsibilities:

  * Communicate with Rails API
  * Encapsulate data
  * Encapsulate methods related to data

### Your Models

You should have the following models:

  * User
  * Photo
  * Tag

Each of your models should have the following properties:

  * Constructor that can take a JavaScript object with its attributes
    (i.e. mass assignment)
  * CRUD AJAX methods: your AJAX methods should communicate with the server,
    get the necessary data, and process that data by setting the
    properties of the model.
      
      * `save`: Should persist the model to the Rails API appropriately
        (i.e. make the right AJAX request). `save` should not do
        anything other than delegate to `update` or `create` depending
        on whether it's a new record or not.
      * `fetch`: Should get a single record's data and update its own
        properties with whatever came back from the server. 
      * `destroy`: Should destroy the record on the server

  * Callbacks in AJAX methods: all of your AJAX methods should
    optionally take a callback, which should be called when the AJAX
    response comes back (make sure to hand the callback something
    sensible, like the model object that includes the data that came
    back in the response.
  * `baseUrl`: A property that encodes the base URL for AJAX requests
    (e.g. `/photos`). Your AJAX methods should use this to construct the
    proper URL to make requests to.
  * Class properties (i.e. properties not on the prototype but on the
    constructor itself):

      * `all`: Should be an array of model objects. Make sure to keep
        this updated.
      * `fetch`: Should fetch all records from the server and reset `all`
      * `find`: Should search through `all` for a model object with the
        given id

At the end of this phase, you should have all your data abstracted out
into JavaScript classes that can communicate with the server.

## Phase III: View Controllers (+ templates)

Next, you'll create controller objects. We'll call them
`ViewControllers` since we'll have one per "view." Create a
`PhotosViewController` and a `TaggingViewController`. 

*NB: In keeping with our code organization focus, you'll put these
controllers in the `javascripts/` directory in a subfolder called
`controllers/`.*

Each should take in their constructor a JQuery object that is the
element they should render into. Each should also have a `render`
method. The `TaggingViewController` should also take a photo in its
constructor. 

All of your listeners and event handlers should be written in these
controllers. Try to keep each method small, so use named callbacks when
appropriate (i.e. not anonymous functions). 

### Templates

For templates you will need the `ejs` gem. All of your templates should go in 
a `templates/` folder under `javascripts/` and end in `.jst.ejs`. Accessing them 
in your JavaScript code can be done through the `JST` global variable. 

For example:

`app/assets/javascripts/templates/fancy.jst.ejs`:

```
Hi <%= name %>
```

`app/assets/javascripts/controllers/dummyController.js`:

```
templateFunction = JST['fancy'];
renderedTemplate = templateFunction({name: 'World'});
console.log(renderedTemplate);

// => "Hi World"
```

Note that the `script` tags are unnecessary when you're writing your
templates in a `.jst.ejs` file.

## Tagging Functionality

There are two parts to the tagging functionality.

First, there is the creation of the tag. The user should be able to
click on the photo and see a dropdown of all of his friends. Upon
clicking one of those names, the tag should be created.

Second, there is the rendering of the tag. For this, you'll likely want
to store an `x-coord` and a `y-coord` in *percentage* form. Pixels
wouldn't be very helpful since the photo might be different sizes on
different screens.

Check out the jQuery docs. You'll find that you can get the current
position of the mouse cursor in x & y, which you'll have to compare
against the position and dimensions of the photo to get your percentage
coordinates.

## Flesh it out

Now that you have your basic models, view controllers, and templates
setup, go ahead and implement all the app functionality.


