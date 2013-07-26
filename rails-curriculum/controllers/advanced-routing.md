# Advanced routing

## Nested Resources

It's common to have resources that are logically children of other
resources. For example, suppose your application includes these
models:

```ruby
class Magazine < ActiveRecord::Base
  has_many :ads
end

class Ad < ActiveRecord::Base
  belongs_to :magazine
end
```

Nested routes allow you to capture this relationship in your
routing. In this case, you could include this route declaration:

```ruby
resources :magazines do
  resources :ads
end
```

This generates routes for paths like `/magazines/:magazine_id/ads`,
`/magazines/:magazine_id/ads/:id`, etc. They still route to the same
old `AdsController` actions; this just gives us another way to reach
them.

I strongly recommend restricting nested routes to just collection
actions:

```ruby
resources :magazines do
  resources :ads, :only => [:index, :new, :create]
end

# make all actions available at the top level
resources :ads
```

In my own opinion, there should be a exactly one URL which maps to the
representation of a resource; `/ads/101` and `/magazines/42/ads/101`
both route to the same `Ad`. Also, the `/magazines/42` bit is
redundant; `AdsController#show` can infer the associated `Magazine` id
with just the `Ad` id (`Ad.find(id).magazine_id`).

This is ugly and silly; avoid this by forgoing all member actions on a
nested resource. Also, by restricting ourselves to collection methods,
we avoid the horror which comes from deeply nested routes (>2
resources deep). That's an ugly road.

However, the nested `index` and `new` routes can be handy. Consider
the following code:

```ruby
class AdsController
  def index
    if params.include?(:magazine_id)
      @ads = Ad.where(:magazine_id => params[:magazine_id])
    else
      @ads = Ad.all
    end
    
    render :index
  end

  def new
    @ad = Ad.new(:magazine_id => params[:magazine_id])
    
    render :new
  end
end
```

We can get urls for these methods with the helpers
`magazine_ads_url(@magazine)` and `new_magazine_ad_url(@magazine)`.

A quick note of what the form view might look like:

```html+erb
<%= form_for(@ad) do |f| %>
  <%= f.hidden_field :magazine_id %>
  
  ...
<% end %>
```

We need to add the hidden field, or else when we post our form, the
controller won't know what magazine to create the `Ad` for. Here we
capture the appropriate `Magazine`'s id in the form (albeit it hidden
and not visible to the user), so that it can eventually be uploaded.

Note that it doesn't make a lot of sense to post the form to
`magazine_ads_url`. Posting to `magazine_ads_url(@magazine)` would
allow us to extract the `magazine_id` from the url (instead of from
the form), but requires more setup and hassel. Forget that, just post
to `ads_url` as normal.

## Adding new REST actions

Rails has support for adding new routes for actions beyond the default
RESTful seven:

```
resources :photos do
  member do
    post 'upvote'
  end

  collection do
    get 'most_popular'
  end
end
```

In this way we add new member (meant to be called on a single object,
like `/photos/123/upvote`) or collection (`/photos/most_popular`)
actions. We use `get`/`post` (or `delete`, `put`, etc) to specify what
HTTP method should be used.

Avoid adding new actions; they break the idioms of REST. Instead, you
should think about whether these new actions hint at additional
resources. For instance, we might create a `VotesController`;
`VotesController#create` would register a vote for a photo. We can do
this even if there is no `Vote` model (shock!).

Likewise, `most_popular` may be better expressed as a query-string
option to `PhotosController#index`. You can generate such a url with
`photos_url(:most_popular => true)`.

A word on the philosophy of REST. REST proposes that your task as an
API designer is to find *resources*, which have a limited number of
conventional, idiomatic methods. REST sort of turns object-orientation
on its head: instead of defining new actions on your objects, you define
new resources which "factor out" functionality.

You needn't be dogmatic about your adherence to REST; a few extra
actions won't hurt anyone. However, the less conventional your
interface, the greater the learning curve for your API
consumers. Also, the more actions you add, the more complicated your
controllers become. When we want to expand past the seven conventional
REST actions, we probably have a controller that wants to do too much.
