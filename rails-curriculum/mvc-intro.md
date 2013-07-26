# Introduction to Model-View-Controller (and routing!)

The model-view-controller architecture is a way of structuring a web
app. This conventional structure helps you to order your code and
makes it tractable to understand your program. In this way, it has the
same goals as object-oriented programming.

## Revisiting HTTP

*NB: Please review the [HTTP reading][http-reading] before proceeding.*

[http-reading]: https://github.com/appacademy/ruby-curriculum/blob/master/the-web/http.md

Before we get into each layer's role and responsibilities, let's
sketch out a single request's lifecycle so we can see where
each piece would fit in.

Think for a second of your application as a black box - a module
upon which you call a method and expect a certain output, but
you don't care how that method is implemented. We'll dig into the
black box in just a second.

The method called is an HTTP request. From the outside world, your
application has a public interface that is accessible over HTTP.
For example, `GET /index.html` may be one method. The
output is an HTTP response. It is often a page of HTML which
then renders on the user's browser.

* Method (Request): `GET /index.html`
* Black Box (Application)
* Output (Response): Index HTML page

What we care about when architecting our applications is how we
take in a request and then generate a response - i.e. how we
architect the black box in the middle.

## The Router, Controller, View Pipeline

* Request: `GET /index.html`
* Black Box (Application)
* Response: Index HTML page

Once the request shows up at our application (i.e. it's been
routed through the interwebs and been dropped off to our
application server), what do we do with it?

Well, one general pattern we use is to match up *one route
with one action*. That is, for each individual url in our
application, we have a single Ruby method to deal with it.
'GET /index' is one method. 'POST /users' is another. And so
on.

Those methods live in **controllers**. Controllers will do
the work that's necessary to construct the response for an
individual request.

The **router** does something simple but crucial.
It does the work of mapping the url to a
specific controller action. You request `GET /index` and the
first thing your application does is hand the request to the
router and asks, "Hey, we've got a request at this url; which
controller does it go to and which method should be called?"
You get to define which url's trigger which controller actions.

Once the request gets to the controller, it's the controllers
job to do whatever is necessary for that request and generate
a response. Usually what it will do is grab some information
from one or more **models** and then hand that information over
to a **view** to construct an HTML response and then fires
that back to the requester.

Note though that it is not necessary for the controller to
interact with the models. The models are totally ignorant of
the outside world and the request-response lifecycle. They are
there as libraries to be used by the controllers. The controllers
are the ones that actually deal with requests and specify
responses - models hang back.

* Request: `GET /index.html`

---
**APPLICATION**
* **Router**: `GET /index.html` maps to Home Controller,
  'index' method
* **Home Controller**: `index` method called
    * Get a list of recent posts
      * **Post Model**: Get recent posts out of database
    * Render HTML **Index View** with all those posts

---
* Response: Index HTML page

## MVC

This structure delegates responsibility for representing and storing
the data (Model), performing actions in response to a user request
(Controller), and formatting the response (View). The Routing layer
will translate incoming user URL requests to controller actions to be
executed.

**NB:** You should recognize this structure loosely in the applications
you've already been building in class. Your 'library' is analogous to
the model layer, and your 'script' took care of both structuring the
flow of the application (controller) and presenting information to
the user (view).

## The model layer

By this time, we have a great deal of experience building model
objects; we fetch and save data from our database through the model
classes. Likewise, models have methods that allow us to interact with
the data.

```ruby
# app/models/secret.rb
class Secret < ActiveRecord::Base
  attr_accessible :body

  belongs_to :user
end

# app/models/user.rb
class User < ActiveRecord::Base
  attr_accessible :name

  has_many :secrets
end
```

This lets us write in the console:

```ruby
Loading development environment (Rails 3.2.11)
1.9.3p194 :001 > u = User.first
  User Load (0.4ms)  SELECT "users".* FROM "users" LIMIT 1
 => #<User id: 1, name: "Ned", created_at: "2013-01-30 19:09:07", updated_at: "2013-01-30 19:09:07">
1.9.3p194 :002 > u.secrets
  Secret Load (0.1ms)  SELECT "secrets".* FROM "secrets" WHERE "secrets"."user_id" = 1
 => [#<Secret id: 1, user_id: 1, body: "Too secret to say", created_at: "2013-01-30 18:56:05", updated_at: "2013-01-30 19:09:18">]
```

The model layer is in a way the most pure; it doesn't contain any
user-interaction code. In fact, it doesn't even care that this is a
web-app; we've built command-line clients to interact with the models.

The rest of MVC (plus routes) is to give a user a way to interact with
the models through a web browser. But the concerns of UI will never
infect the purity of the model layer.

Your application will have many models - usually one per database
table.

## The controller layer

The controller layer is where we write the code that will take an
action on behalf of a user. For instance, let's write a controller
that will list all of the secrets in the database:

```ruby
# app/controllers/secrets_controller.rb
class SecretsController < ApplicationController
  def index
    @secrets = Secret.all

    render :json => @secrets
  end
end
```

The `SecretsController` is responsible for managing the user's
interaction with the `Secret` model. The `index` action will fetch all
the secrets from the database. This is a simple action (just fetches
all the `Secret`s), but other actions can be more complicated.

At the end, the controller hands the data off so that it will be
*rendered* to JSON format and returned to the user.

Your application will have many controllers and it is not necessary
for them to map one-to-one with a model.

### The routing layer
The controller knows how to do work on behalf of the user to satisfy a
request, but how does a web-request cause a controller action to be
fired? This is the job of the routing layer: to translate a
url-request to a controller and action.

```ruby
# config/routes.rb
SecretApp::Application.routes.draw do
  resources :secrets
  # more routing rules...
end
```

We will talk more about how routing works, but for now, know that to
set up routes to the SecretsController's actions, write `resources
:secrets`. We can see the current routes with `rake routes`:

```
~/SecretApp$ rake routes
    secrets GET    /secrets(.:format)          secrets#index
            POST   /secrets(.:format)          secrets#create
 new_secret GET    /secrets/new(.:format)      secrets#new
edit_secret GET    /secrets/:id/edit(.:format) secrets#edit
     secret GET    /secrets/:id(.:format)      secrets#show
            PUT    /secrets/:id(.:format)      secrets#update
            DELETE /secrets/:id(.:format)      secrets#destroy
```

This says that a `GET` request for `/secrets` will trigger
`SecretsController#index`. Likewise, a `POST` to `/secrets` will ask the
`UsersController` to run its `create` action.

To see, fire up the Rails server:

```
~/SecretApp$ rails s
=> Booting WEBrick
=> Rails 3.2.11 application starting in development on http://0.0.0.0:3000
=> Call with -d to detach
=> Ctrl-C to shutdown server
[2013-01-30 15:04:42] INFO  WEBrick 1.3.1
[2013-01-30 15:04:42] INFO  ruby 1.9.3 (2012-04-20) [x86_64-darwin12.0.0]
[2013-01-30 15:04:42] INFO  WEBrick::HTTPServer#start: pid=9268 port=3000
```

And then let's make a request:

```
[1] pry(main)> require 'rest-client'
=> true
[2] pry(main)> require 'json'
=> true
[3] pry(main)> JSON.parse(RestClient.get("localhost:3000/secrets"))
=> [{"body"=>"Too secret to say",
  "created_at"=>"2013-01-30T18:56:05Z",
  "id"=>1,
  "updated_at"=>"2013-01-30T19:09:18Z",
  "user_id"=>1},
 {"body"=>"Another secret!",
  "created_at"=>"2013-01-30T19:32:09Z",
  "id"=>2,
  "updated_at"=>"2013-01-30T19:32:09Z",
  "user_id"=>nil}]
```

Your application will only have one router.

## The view layer

The controller's responsibility is to take actions on behalf of the
user; to do this it may fetch or save models. When done, it's time to
return a response to the user.

In the above example, we called `render :json => secrets` to render
the data. For more complicated representations, we delegate the
responsibility of rendering the response to the view layer.

Here, for instance, is an ERB (embedded Ruby) *template* that renders
the response of the `index` action:

```html+erb
<!-- app/views/secrets/index.html.erb -->
<ul>
  <% @secrets.each_with_index do |secret, i| %>
    <li>
      Secret #<%= i %>: <%= secret.body %>
    </li>
  <% end %>
</ul>
```

The controller may invoke the view like so:

```ruby
class SecretsController < ApplicationController
  def index
    @secrets = Secret.all

    # render :json => @secrets
    render :index
  end
end
```

Rails will look for the appropriately named ERB file in
`views/secrets`. It will then be filled out and returned to the user.

Your application will have many views - usually one per controller
action.

## The Basic Lifecycle of a Rails Request

1. An HTTP request hits the router.
2. The router matches the request (the HTTP method and URL) to a controller
   action and triggers that action.
3. The controller action executes, usually interacting with one or more models
   in some way (i.e. retrieving or manipulating data).
4. The controller generates a response and sends it to the user. Usually, that
   means that the controller will render a view and send it in the response
   body.
