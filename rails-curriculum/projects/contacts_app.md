# Layering on Contacts

We're going to continue building on the API we built in the first
project.

Today's goal is to make a contacts application. Your users will be
able to send requests to our API in order to create contacts and
retrieve contact information, as well as specify some favorite
contacts.

## Data Layer

You almost always start with the data layer when you're thinking about
adding functionality. What pieces of data are necessary to implement
the functionality you need? What changes need to be made to the database
schema? What models do you need? What associations and validations?

Go ahead and add models and the relevant associations and
validations for:

  * Contacts (name, email, phone number, address)
  * Favorites

## API Layer

Next you usually move to the API layer: how you will be *exposing* your
data, specifying how the outside world can interact with it.

The API layer consists of the router and the controller.

Go ahead and sketch out how the routes might look. The first step is
to identify the resources your application is dealing with (what will
you be CRUDing?).

Make sure you use your knowledge of nested routes to make the API as
sensible and usable as possible. Also use your knowledge of how to
exclude/include routes with `:only` and `:except` so that you only
have the routes you need. Exposing unused routes is just asking for
trouble.

Now think about how you expect data to come in to each route and build
out the relevant controllers and controller actions.

### Nested Routes & Controller Actions

With a nested route, what do the params look like?

Note that you have an extra field in the route (i.e. `:user_id` if you
nest contacts under users). So, `/users/5/contacts` would return the
contacts for User with id 5.

But then when we wanted to see an individual contact, we'd again have
to specify the first part of the url (`/users/5/contacts/27`) which
doesn't make much sense given the fact that the contact's id is
unique - there is no need to nest it under a user.

Here's a common pattern:

```
resources :users do
  resources :contacts, :only => [:index]
end

resources :contacts, :except => [:index]
```
We keep the nested index action, but the rest we put on the top level.
You may not want to follow this exactly (maybe you want to nest
`create` too for example) but always be thinking about the API
endpoints you're building.

Take a look at how the routes lay out with this construction by
running `rake routes`.

Feel free to refer the to the relevant Rails guides as you go:

* [Rails Guides - Routes][rails-routes]
* [Rails Guides - Controllers][rails-controllers]

[rails-routes]: http://guides.rubyonrails.org/routing.html
[rails-controllers]: http://guides.rubyonrails.org/action_controller_overview.html


### Helpful hints:
* When something goes wrong, consult your server logs before
  asking your TA.
* Get used to reading the server logs. It is something you will be
  doing **all the time** as a Rails developer. The server logs are your
  window to incoming requests, you will have to look to see what
  `params` are being sent to the server.
* **Remember to use Git and to commit your work regularly.** Think
about what you want your next commit to be and focus on building that -
then commit with a good message.

## Authentication & Sessions

At this point, you should have a fully functioning API that can CRUD
users, contacts, and favorites. Get a once over by your TA before
you continue.

One issue we have is that anybody can access anybody's contacts as well
as manipulate those contacts. We have validations on the model level
to maintain data integrity, but we don't do anything to ensure that
the person trying to access the data is authorized to do so.

Well, we read about authentication yesterday, and we used OAuth to
interact with Twitter and Google's APIs. Let's build something that
accomplishes the same thing.

In the reading yesterday, it mentioned that cookies were one way of
implementing authentication. But we're not using a browser to interact
with this application, so there are no cookies to use.

Instead, we'll implement something similar to OAuth by providing a token
to logged in users that they will send along with every request. Then in
our controllers we can check for the presence of that token and respond
accordingly.

*NB: Note that as always, we want to return sensible status codes,
so if a user is trying to access something that he's not authorized
to see, make sure you provide a status code that indicates as much.*

### Data Layer

As always, we start with the data layer. What pieces of data are
required for authentication.

1. How will the user authenticate? Maybe email & password.
2. How will we generate a token for a user?
3. For a logged-in user (i.e. one that has a token), how will we
find the user for a certain token?

### API Layer

Create a custom route that will be where the user authenticates.

They'll be POSTing their username and password. In the authentication
action, you'll need to check to make sure the password matches
the one in the database. If it does, respond with an access token for
that user that they can send along with every request.

For those actions that serve up protected data, make sure to check if
the current user is authorized to see the data they're requesting.

Here are some common helper methods you should use. You'll have to
flesh them out a bit:

```
class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user ||= ***YOUR CODE HERE***
  end

  def logged_in?
    !!current_user
  end
end
```

By putting these methods in `ApplicationController`, they're
available to all your other controllers.

Note that you may have a lot of duplicated code for checking if a user
is authorized. One way to clean up such code in controllers is to use
a `before_filter`. For example:

```
class ContactsController < ApplicationController
  before_filter :authenticate_user

  ...
```

`before_filter` is a class method that takes a list of symbols that
are the names of methods to be run before all controller actions in
the controller that declares the filter. Note that you still would
have to implement the `#authenticate_user` method. You can also
constrain which actions the filter runs on using `:only` and
`:except` (similar to constraining resources in the router).

**Make sure you continue to use your script with RestClient to test
and interact with your API.**

## SDK

At this point, our API is complete. We can CRUD users, contacts, and
favorites, and we've implemented a simple authentication solution so
that users can't see or manipulate each other's contacts.

But it's a bit of a pain to interact with our API right now through
our script since we have to include the token every single time.

Let's build a small library (similar to the OAuth gem) that will
abstract away requesting and including that token.

Through your library, you should be able to get the access token
(note that you'll need to pass in an email and password), and make
GET, POST, PUT, and DELETE requests. Abstract all this away through
some nice methods like the OAuth gem.

## Extra Credit

* Search contacts

  Create a custom `search` route under contacts and a matching
  controller action. The controller action should take the query
  and return contacts that match the query. First just allow
  a user to search by name, but then make it more extensible so
  they could search by email or by any field.

  Even though we're sending data, a search is still simply trying
  to read resources, so it will be a GET request with a query
  string. Note that Google searches are all GET requests.
 
* Create a `#to_param` method to implement slugs (human readable ids) in your routes.

* Suggest new contacts. You can do this by:
  - Looking through all of your contacts' contacts, and find the
    most frequent contacts which you do not have.
* Two+ query search.
* Generate Gravatar links.

