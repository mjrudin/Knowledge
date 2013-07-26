# Controller

## What Does a Controller Do?

Action Controller is the C in MVC. After routing has determined which
controller to use for a request, your controller is responsible for
making sense of the request and producing the appropriate
output. Luckily, Action Controller does most of the groundwork for you
and uses smart conventions to make this as straightforward as
possible.

A controller can be thought of as a middle man between models and
views. It makes the model data available to the view so it can display
that data to the user, and it saves or updates data submitted by the
user to the model.

## Methods and Actions

A controller is a Ruby class which inherits from
`ApplicationController` and has methods just like any other
class. When your application receives a request, the routing will
determine which *controller and action* to run, then Rails creates an
instance of that controller and runs the method with the same name as
the action.

```ruby
class ClientsController < ApplicationController
  def new
    render :new
  end
end
```

As an example, if a user goes to `/clients/new` in your application to
add a new client, the router will recognize that it should call
`ClientsController#new`. It will create an instance of
`ClientsController` and run the `new` method. In the simple example
above the controller will then render the `new.html.erb` view.

**Note that controller naming convention is to pluralize the name of
the model, and tack on "controller"**

## Parameters

You will probably want to access data sent in by the user or other
parameters in your controller actions. There are two kinds of
parameters possible in a web application. The first are parameters
that are sent as part of the URL, called query string parameters. The
query string is everything after "?" in the URL. The second type of
parameter is usually referred to as POST data. This information
usually comes from an HTML form which has been filled in by the
user. It's called POST data because it can only be sent as part of an
HTTP POST request. Rails does not make any distinction between query
string parameters and POST parameters, and both are available in the
`params` hash in your controller:

```ruby
class ClientsController < ActionController::Base
  # This action uses query string parameters because it gets run
  # by an HTTP GET request, but this does not make any difference
  # to the way in which the parameters are accessed. The URL for
  # this action would look like this in order to list activated
  # clients: /clients?status=activated
  def index
    if params[:status] == "activated"
      @clients = Client.activated
    else
      @clients = Client.unactivated
    end

    # render the index template and send back to client
    render :index
  end

  # This action uses POST parameters. They are most likely coming
  # from an HTML form which the user has submitted. The URL for
  # this RESTful request will be "/clients", and the data will be
  # sent as part of the request body.
  # A JSON payload looks like this:
  # { client: {
  #     name: "Ned",
  #     address: "3742 26th St."
  #   }
  # }
  def create
    # The JSON body will be parsed by Rails; params[:client] is the
    # nested hash of client attributes. This can be passed to
    # `Client.new` to "mass-assign" the values.
    @client = Client.new(params[:client])

    # ...
  end
end
```

### Routing Parameters

Controller actions like `show`, `edit`, and `delete` operate on an
instance of the `Photo` model. For instance, if a url `/photos/1234`
is sent to the router, it will match this with the route `/photos/:id`
and invoke the `PhotosController#show` action.

To tell the controller what object we are talking about, the router
will set an `:id` attribute with the matched id (1234). This can be
accessed by the controller through `params[:id]` and used to find the
object in question.

## Instance variables

A controller often fetches data from models; it can communicate this
data to the view through instance variables:

```ruby
class PostsController
  def index
    @posts = Post.all

    render :index
  end
end
```

Objects saved in instance variables will be available for use within
view templates. We'll learn how to use them in the [ERB](erb.html)
guide.

### The request-response lifecycle

When a client makes an HTTP request, the websever receives it and
hands it off to Rails. The Rails router looks up the controller action
to call. As mentioned, it **creates an instance of the controller** to
handle the response. The controller then takes some action, including
setting instance variables, and then renders a response. After issuing
the response, the request is considered satisfied, the connection
between client-and-server is closed, and the controller instance is
discarded.

In particular, setting instance variables in the controller **does not
affect the processing of future requests**. State is saved either in
the database (server-side) or the cookie (client-side). Since instance
variables will be lost (along with the controller) after the response
is issued, their primary use is to communicate data to the view
layer. More on this in the views and ERB chapters...

## Additional Reading

[Rails Guide on Controllers][rails-controllers]

[rails-controllers]: http://guides.rubyonrails.org/action_controller_overview.html
