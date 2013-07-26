# Templates

As we've discussed, controllers cause templates to be rendered by
calling the `render` method. But how are templates structured?

With HTML and ERB.

## ERB (embedded Ruby)

Templates consist of HTML, but they are augmented with Ruby code. ERB
templates are pretty simple:

* `<% ruby_code_here %>` executes Ruby code that does not return
  anything. For example, conditions, loops or blocks.
* `<%= %>` is used when you want to embed the return value into the
  template. i.e. Something that will actually show up in the HTML.

For example:

```html+erb
<b>Names of all the people</b>
<ul>
  <% ["Tom", "Dick", "Harry"].each do |name| %>
    <li>
      Name: <%= name %>
    </li>
  <% end %>
</ul>
```

The loop is setup in regular embedding tags `<% %>` and the name is
written using the output embedding tag `<%= %>`. Output functions like
print or puts won't work with ERB templates. So this would be wrong:

```html+erb
<!-- WRONG -->
Hi, Mr. <% puts "Frodo" %>
```

It's important to note that the ERB is simply helping construct HTML.
When the view is finished rendering, it will be pure HTML and it is
pure HTML when it is sent out to the user.

### Commenting out ERB

Say you want to comment out some broken Ruby code in your ERB file
that's throwing an error:

```html+erb
<!-- <%= my_broken_ruby_code %> -->
```

Even though you wrap the embedded Ruby in an HTML comment, the Ruby
code will still be evaluated, and you'll still get an error.

To do this, simply add a '#'. So:

```html+erb
<%#= my_broken_ruby_code %>
```

The '%#' means to not evaluate the embedded Ruby. The '=' is dangling.

## Instance variables

Controllers make data available to the view layer by setting instance
variables. It seems a bit silly that this is the mechanism by which data
is shared since instance variables are all about keeping private data,
but that's how Rails does it. When the view is rendered, it copies over
the instance variables of the controller so that it has access to them;
the view cannot otherwise get access to the controller or its
attributes.

Let's give a full example:

```ruby
# app/controllers/products_controller.rb
class ProductsController < ActionController::Base
  def index
    # get an array of all products, make it available to view
    @products = Products.all
  end
end
```

```html+erb
<!-- app/views/products/index.html.erb -->
<h1>All the products!</h1>
<ul>
  <% @products.each do |product| %>
    <li>
      <%= product.name %>
    </li>
  <% end %>
</ul>
```

## View Helpers

To help us generate HTML, we may use *helper* methods. Helpers are
defined in `app/helpers`, and contain view-specific Ruby code. We'll
talk about writing our own helpers in a later chapter, but first we'll
talk about built-in helper methods that are provided by Rails.

### links and buttons

You may have seen `link_to` around before; it generates the HTML code
for a link. Here's a few uses:

```html+erb
<%= link_to "Cat Pictures", "http://cashcats.biz" %>
<a href="http://cashcats.biz">Cat Pictures</a>

<%= link_to "New Application", new_application_path %>
<a href="www.example.com/applications/new">New Application</a>
```

When a user clicks on an anchor tag, a `GET` request is issued. If you
want to issue a `POST`, `PUT`, or `DELETE` request, you can use a
button and specify the method:

```html+erb
<%= button_to "Delete post", application_url(@application), :method => :delete %>
```

**Do not rely on these helper methods blindly. *Always* look at the
HTML they generate. You should be able to generate the same HTML.**

Often you want to send some parameters along with the request; for
instance, you want to make a `POST` request to create a new
`Application`, passing in the applicant's name, city, etc. To do this,
we want to create an HTML *form*; we'll learn how to do this in a
later chapter.

See the [URLHelper docs][url-helper-docs] for more info on `link_to`
and `button_to`.

## Image tags

To insert an image, we use the Rails `image_tag` helper. This will
reference an image in your `public/` directory.

```
<%= image_tag("icon.png") %>

<img src="/assets/icon.png" alt="Icon" />
```

```
<%= image_tag(
    "photo.jpg",
    :width => '1024px',
    :alt => "beautiful photo description here"
) %>

<img alt="beautiful photo description here"
     src="/assets/phot.jpg"
     width="1024px" />

```

See the docs for more [`image_tag` options][image-tag-docs].

## Resources

* [URLHelper docs][url-helper-docs]
* [image_tag docs][image-tag-docs]

[url-helper-docs]: http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html
[image-tag-docs]: http://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-image_tag