# Basic Routing

## The Purpose of the Rails Router

The Rails router recognizes URLs and dispatches them to a controller's
action. It's the part which receives a `GET` request for
`/patients/17` and realizes that `PatientsController#show` should be
called for Patient #17.

Note that the router matches on both HTTP method and path.

It dictates the structure of your API - all the urls your API can
process are defined in the router.

The router can also generate paths and URLs, avoiding the need to
hardcode strings in your views.

## Resource Routing: the Rails Default

Say that we have a `Post` model, and we would like to begin buildling
a `PostsController` to display posts, create new ones, edit
existing ones, delete old ones...

*Resource routing* will generate a mapping from a set of conventional
url paths to a set of conventional controller actions. Let's create
our first resource routing like so:

```ruby
FlickClone::Application.routes.draw do
  resources :photos
end
```

This single line will generate a map of the following requests for URLs to
a set of controller actions in the `PostsController`.

| HTTP Verb | Path             | action  | used for                                     |
| --------- | ---------------- | ------- | -------------------------------------------- |
| GET       | /photos          | index   | display a list of all photos                 |
| GET       | /photos/new      | new     | return an HTML form for creating a new photo |
| POST      | /photos          | create  | create a new photo                           |
| GET       | /photos/:id      | show    | display a specific photo                     |
| GET       | /photos/:id/edit | edit    | return an HTML form for editing a photo      |
| PATCH/PUT | /photos/:id      | update  | update a specific photo                      |
| DELETE    | /photos/:id      | destroy | delete a specific photo                      |

The areas in the path that start with a ':' are dynamic matchers. That
is, these routes are underneath really just regular expressions being
matched against the request path that comes in. 'GET /photos/5' and
'GET /photos/203' both map to the same controller action ('show'), but
the ':id' parameter is 5 in the first request and 203 in the second.

We will initially use the primary key of the model where it has ':id'.

Your routes are now set up: begin writing your controller actions to
implement these actions!

## Inspecting and Testing Routes

To get a complete list of the available routes in your application,
execute the `rake routes` command in your terminal. This will list all
of your routes, in the same order that they appear in `routes.rb`. For
each route, you'll see:

* The route name (if any); you can tack '_url' after this to get the
  url helper.
* The HTTP verb used
* The URL pattern to match
* The `controller#action` to route to

For example, here's a small section of the `rake routes` output for a
RESTful route:

```
    users GET    /users(.:format)          users#index
          POST   /users(.:format)          users#create
 new_user GET    /users/new(.:format)      users#new
edit_user GET    /users/:id/edit(.:format) users#edit
```

TIP: You'll find that the output from `rake routes` is much more
readable if you widen your terminal window until the output lines
don't wrap.

## Paths and URL Helpers

Creating a resourceful route will also expose a number of *url helpers*
to the controllers and views in your application. In the case of
`resources :photos`:

* `photos_path` returns `/photos`
* `new_photo_path` returns `/photos/new`
* `photo_path(@photo)` returns `/photos/#{@photo}`, assuming that
  `@photo` is a `Photo`
* `edit_photo_path(@photo)` returns `/photos/#{@photo.id}/edit`,
  assuming that `@photo` is a `Photo`.

**Always prefer the url helpers to building your own urls through
string interpolation**. The URL helpers are less error prone and
tedious. They also are more semantically clear, and more easily
changed.

Because the router looks at the HTTP verb when routing a request
for a path, four URLs map to seven actions. Many methods that take a
url will also accept a `:method` option to specify the option (e.g.,
`button_to(photo_url(@photo), :method => :destroy)`).

Finally, note that you can embed query-string options into the
url-helpers easily: `photos_url(:recent => true)` may generate
`/photos?recent=true`.

## Adding additional actions

You are not limited to the seven routes that RESTful routing creates
by default. If you like, you may add additional routes that apply to
the collection or individual members of the collection.

### Adding Member Routes

To add a member route, just add a `member` block into the resource
block:

```ruby
resources :photos do
  member do
    get 'preview'
  end
end
```

A GET request for `/photos/1/preview` will be routed to the `preview`
action of `PhotosController`. It will also create a
`preview_photo_url` helper.

Within the block of member routes, each route name specifies the HTTP
verb that it will recognize. You can use `get`, `patch`, `put`,
`post`, or `delete` here.

### Adding Collection Routes

To add a route to the collection:

```ruby
resources :photos do
  collection do
    get 'search'
  end
end
```

This will enable Rails to recognize paths such as `/photos/search`
with GET, and route to the `search` action of `PhotosController`. It
will also create a `search_photos_url` helper.

### A Note of Caution

If you find yourself adding many extra actions to a resourceful route,
it's time to stop and ask yourself whether you're disguising the
presence of another resource. You don't want to bastardize resourceful
routing by adding gobs of routes willy-nilly. Then you lose the
benefits of the structure that Rails conventions and REST provide.

### Restricting the Routes Created

By default, Rails creates routes for the seven default actions (index,
show, new, create, edit, update, and destroy) for every RESTful route
in your application. You can use the `:only` and `:except` options to
fine-tune this behavior. The `:only` option tells Rails to create only
the specified routes:

```ruby
resources :photos, :only => [:index, :show]
```

Now, a `GET` request to `/photos` would succeed, but a `POST` request
to `/photos` (which would ordinarily be routed to the `create` action)
will fail.

The `:except` option specifies a route or list of routes that Rails
should _not_ create:

```ruby
resources :photos, :except => :destroy
```

In this case, Rails will create all of the normal routes except the
route for `destroy` (a `DELETE` request to `/photos/:id`).

TIP: If your application has many RESTful routes, using `:only` and
`:except` to generate only the routes that you actually need can cut
down on memory use and speed up the routing process.

## Using `root`

You can specify what Rails should route `"/"` to with the `root` method:

```ruby
root :to => 'pages#main'
```

You should put the `root` route at the top of the file, because it is
the most popular route and should be matched first. You also need to
delete the `public/index.html` file for the root route to take effect.

## Additional Resources

[Rails Guide on Routing][rails-routing]

[rails-routing]: http://guides.rubyonrails.org/routing.html
