# Controllers and State

## [Session](http://guides.rubyonrails.org/action_controller_overview.html#session)

HTTP is *stateless*. That means requests are handled independently
from one another; your Rails controller dies at the end of every
request (i.e. each request is handled by a new instance of the
controller). But oftentimes we need to track information across
requests.

We can store some information across requests by having the Rails
application store it in the database. For instance, when a user signs
up for our service, we `create` a new `User` object and store his/her
credentials in the `users` table.

Sometimes the **client** needs to store data across requests. For
instance, think about login functionality. Let's break this down for
the example of facebook:

0. Facebook presents a login page when you goto facebook.com and are
   not logged in.
0. User fills out the web form, presses "submit". The web browser
   makes an HTTP request to POST credentials to the Facebook's server
   (perhaps to `/session/new`).
0. Facebook server verifies username/password. Sends a redirect to the
   browser instructing it to GET `/feed`.
0. Client makes GET request for `/feed`.

The problem is in the last step. From the point of view of Facebook's
server, the GET for `/feed` is entirely unrelated to the POST to
`/session/new`. Not being able to connect these two requests means
that the GET for `/feed` looks like it's coming from an un-logged-in
user.

How would Rails connect these two requests? They hit different
controllers; even if they hit the same controller, the controller is
thrown away at the end of the request anyway.

To fix this problem, we need to have the client web browser store some
data for us. Check it out:

0. Facebook presents a login page when you goto facebook.com and are
   not logged in.
0. User fills out the web form, presses "submit". The web browser
   makes an HTTP request to POST credentials to the Facebook's server
   (perhaps to `/session/new`).
0. Facebook server verifies username/password. Sends a redirect to the
   browser instructing it to GET `/feed`.
    * **Also, Facebook generates a temporary *login token* for the user**.
    * **Facebook sends the token back with the redirect response**.
0. Client makes GET request for `/feed`.
    * **Client uploads the login token**.
    * **Facebook looks up the user associated with the login token and
      shows his/her feed**.

The way Rails asks the client to submit the token on every request is
by setting a cookie. This is the most classic use of cookies.

Rails does much of the work of implementing the session for us. Within
our controller, we can use the `ActionController::Base#session` method
to get a hash-like object where we can retrieve and set state
(e.g. `session[:user_id] = @user.id`). Rails does the rest by storing
that data in the user's cookies.

Here's a barebones, dead-simple demo:

```ruby
# config/routes.rb
SecretApp::Application.routes.draw do
  resource :feed
  resource :login

  root :to => "secrets#index"
end

# app/controllers/sessions_controller.rb
class SessionsController < ActionController::Base
  def create
    username = params[:user_name]
    password = params[:password]

    u = User.where(
      :username => username,
      :password => password
    ).first

    # generate a 16-digit random token
    u.session_token = SecureRandom::urlsafe_base64(16)
    u.save!

    # put the generated token in the client's cookies
    session[:session_token] = u.session_token
    redirect_to feed_url
  end
end

# app/controllers/feeds_controller.rb
class FeedsController < ActionController::Base
  def show
    # pull the session token out of the client's cookies
    # it will be right where we left it in session[:session_token]
    session_token = session[:session_token]
    @u = User.find_by_session_token(
      session_token
    )

    # render feed for user...
  end
end
```

Anything you set in `session` will be stored in the cookie. On
subsequent requests you can fetch the stored result by looking up the
value in `session`.

Note that like `params`, `session` is actually a call to
`ActionController::Base#session`, which returns a hash-like
object. Changes to this hash instruct Rails to send changes to the
cookie back with the HTTP response.

To remove something from the `session`, set it to `nil`:

```ruby
class SessionsController < ActionController::Base
  def destroy
    # logout
    session_token = session[:session_token]
    u = User.find_by_session_token(
      session_token
    )

    u.session_token = nil
    u.save!
    session[:session_token] = nil

    redirect_to root_url
  end
end
```

## The flash

The flash is a special part of the session which is cleared with each
request.  This means that values stored there will only be available
in the next request, which is particularly useful for passing error
messages or other success/failure messages.

It is accessed in much the same way as the session, as a hash (it's a
[FlashHash][flash-hash-doc] instance).

Let's use the act of confirming an object was created. The controller
can set a message which will be displayed to the user on the next
request:

```ruby
class SessionsController < ActionController::Base
  def destroy
    # logout
    session_token = session[:session_token]
    u = User.find_by_session_token(
      session_token
    )

    u.session_token = nil
    u.save!
    session[:session_token] = nil
    
    flash[:notices] ||= []
    flash[:notices] << "You logged out. See you soon!"

    redirect_to root_url
  end
end
```

The flash notice is available for the next controller and view to
use. Let's modify `views/layouts/application.html.erb` (the template
that every template is rendered in) to display notices.

```html+erb
<!-- in views/layouts/application.html.erb -->
<!-- `Object#try` is a Rails addition which will try to call the
      method if the object isn't `nil`.  -->

<!-- ... -->
<% flash[:notices].try(:each) do |msg| %>
  <%= msg %>
<% end %>

<!-- ... -->
```

This way, if an action sets a notice or an alert message, the layout
will display it automatically.

### `flash.now`

By default, adding values to the flash will make them available to the
next request, but sometimes you may want to access those values
sooner: in the same request. In particular, if the `create` action
fails to save a resource and you render the `new` template directly,
that's not going to result in a new request, but you may still want to
display a message using the flash. To do this, you can use `flash.now`
in the same way you use the normal `flash`:

```ruby
class SessionsController < ActionController::Base
  def create    
    username = params[:user_name]
    password = params[:password]

    u = User.where(
      :username => username,
      :password => password
    ).first
    
    if u.nil?
      # uh-oh, bad password
      flash.now[:notices] ||= []
      flash.now[:notices] << "Username/password combo was bad"
      
      render :new
      return
    end

    # ...
  end
end
```

## `cookies` vs. `session`

If we're asking Rails to store data in an HTTP cookie, why is it
called `session`? The reason is that "session" is a more abstract
concept: the *session* is the accumulated context for an HTTP
request. You can store (and remove) data from the session, which will
be available in future requests.

There are different ways to implement a session:

* Store the data in an HTTP cookie: this is the default.
* Store all session data in the server's DB. Instead of setting the
  cookie with the data, only send the database key (the id of the
  session data in the DB) to the client. On subsequent requests the
  client ships the key. Rails looks up this key in the DB when session
  data is requested.

Rails lets you choose between these (I won't tell you how): the
default is to store all session data in the cookie. Cookies are
limited in size: 4kB. If you wanted to store lots more data as part of
the session, you may want to store that server side and just store a
small key with the user. You might also do that if you wanted to store
private data in the cookie and didn't want to send it to the
client. But it is atypical to store private data in the session,
anwyway...

You can also get/set data to an HTTP cookie directly using
`ActionController::Base#cookies`. You won't want to do this often
(don't fixate too much on it), but it does give you a little more
power:

```ruby
session_token = SecureRandom::urlsafe_base64(16)
cookies[:session_token] = {
  :value => session_token,
  :expires => 20.year.from_now
}
```

Cookies will typically expire at the end of a browser session (argh!
session used again another way!). When the user closes the browser,
cookies are by default cleared. But by using the low-level `cookies`
method we can set the cookie to live for up to 20 years (this is the
max allowed by the HTTP cookie specifications).

You can abbreivate this by writing `cookies.permanent[:session_token]
= session_token` (permanent means 20yrs, apparently). This is the
primary reason (like 90% of the cases) for using `cookies` in
preference to `session`. Use `session` for everything else.

One limitation: you cannot store anything other than strings in the
cookie. With `session`, Rails will do some extra work for you so that
you can store other data types like arrays and hashes. That's not
hugely terrible, since it's a mistake to try to serialize large
objects in a cookie anyway (it can only store 4kB at max!).

## Resources

* [FlashHash documentation][flash-hash-doc]

[flash-hash-doc]: http://api.rubyonrails.org/classes/ActionDispatch/Flash/FlashHash.html

