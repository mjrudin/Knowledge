# Building a JSON API

A typical Rails app will have its controllers output HTML that will then
be rendered by the browser making the request, but as we saw yesterday,
browsers aren't the only environment in which requests are made.
Sometimes, requests are being made programmatically. When that's the
case, the requestor would much prefer a more raw representation of the
data rather than a bunch of HTML that includes all sorts of extraneous
information and is difficult to parse.

A web API caters to programmatic interaction with a web application. It
will receive requests and respond with data in a way that can be easily
parsed by the program on the other end.

Consumers of a web API can be third-party developers who are building
applications that interact with yours (think building an application
that uses a user's Facebook friends) or your own applications that live
client-side (JavaScript that's running in the user's browser - we'll
cover this much more in depth when we learn about JavaScript and AJAX).

## JSON

JavaScript Object Notation (JSON) has become a standard data interchange
format because it can easily be represented as a string and uses a
simple and widely understood format: key-value pairs. The JSON Ruby
library parses JSON into a regular Ruby hash.

## JSON & Rails

Rails has robust support for building a programmatic web API on two
important levels: the model layer, and the controller layer. Models all
come built in with a `to_json` method that will take the model's
attributes and attribute values and convert them into a JSON string,
ready for transport.

### Models & `to_json`

Let's take a look at the model layer:

```
$ rails console
> Wizard.first
=> #<Wizard id: 1, fname: "Harry", lname: "Potter", house_id: 1,
school_id: 1, created_at: "2013-06-04 00:31:04",
updated_at: "2013-06-04 00:31:04">

> Wizard.first.to_json
=> "{\"created_at\":\"2013-06-04T00:31:04Z\",\"fname\":\"Harry\",
\"house_id\":1,\"id\":1,\"lname\":\"Potter\",
\"school_id\":1,\"updated_at\":\"2013-06-04T00:31:04Z\"}"
```

Note that the `to_json` method actually produces a JSON string. If you
just wanted to hashify the model object, but not convert it into a
string, you could use the `as_json` method, which will do the conversion
into a hash, but not stringify the data.

### Controllers & `render :json =>`

Controllers, too, support responding to a request with JSON.

Remember that all controller actions must end in some response back to
the requestor. That response in Rails is built by calling either
`render` (places something in the response body) or `redirect_to` (which
sends a redirect response along with the redirect destination).

Oftentimes, when we call `render`, we'll specify a Rails `html.erb`
view. But in this case, we want to send a JSON representation of a
certain object.

Easy enough:

```ruby
class UsersController < ApplicationController
  def index
    users = User.all

    render :json => users
  end

  def show
    user = User.find(params[:id])

    render :json => user
  end
end
```

A few things to note:

* The controller specifies that it is rendering JSON with `render :json
=>`
* Under the hood, the object you pass will automatically have
`to_json` called on it, so there is no need to explicitly call it on
the object.
* `to_json` works on both collections and individual objects
