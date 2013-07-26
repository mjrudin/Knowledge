# Partials

Views can get really long and complicated. Just like you break up long
methods into smaller ones, we break up views into smaller bits, called
*partials*. Like small methods, partials are often reusable in
different views, so they also help us keep our code DRY.

## Naming Partials

To render a partial as part of a view, you use the `render` method
within the view:

```html+erb
<h1>Page title</h1>

<p>
  Here's some content for you
</p>

<!-- insert standard footer -->
<%= render :partial => "footer" %>
```

This will render a template named `_footer.html.erb` and insert the
rendered content at this point within the view. Note the leading
underscore character: partials are named with a leading underscore to
distinguish them from regular views, even though they are referred to
without the underscore. This holds true even when you're pulling in a
partial from another folder:

```html+erb
<%= render :partial => "shared/footer" %>
```

That code will pull in the partial from
`app/views/shared/_footer.html.erb`.

## Using Partials to Simplify Views

One way to use partials is to treat them as the equivalent of
subroutines: as a way to move details out of a view so that you can
grasp what's going on more easily. For example, you might have a view
that looked like this:

```html+erb
<%= render :partial => "shared/ad_banner" %>

<h1>Products</h1>

<p>Here are a few of our fine products:</p>
...

<%= render :partial => "shared/footer" %>
```

Here, the `_ad_banner.html.erb` and `_footer.html.erb` partials could
contain content that is shared among many pages in your
application. You don't need to see the details of these sections when
you're concentrating on a particular page.

### Passing Local Variables

Like methods, you can also pass local variables into partials, making
them even more powerful and flexible. For example, you can use this
technique to reduce duplication between new and edit pages, while
still keeping a bit of distinct content:

```html+erb
<!-- app/views/user/new.html.erb -->
<%= render :partial => "form", :locals => { :user => @user, :action => :new } %>

<!-- app/views/user/edit.html.erb -->
<%= render :partial => "form", :locals => { :user => @user, :action => :edit } %>

<!-- app/views/user/_form.html.erb -->
<!-- Is this a new user to create, or an existing one to edit? -->
<% action_url = (action == :new) ? users_path : user_edit_path(user) %>

<form action="<%= action_url %>" method="post">
  <% if action == :edit %>
    <input type="hidden" name="_method" value="put">
  <% end %>
  <!-- inputs go here... -->
</form>
```

### The Partial Subject

Every partial also has a local variable named `object`. You can set
this with the `:object` option:

```html+erb
<!-- app/views/user/new.html.erb -->
<%= render :partial => "form", :object => @user %>

<!-- app/views/user/edit.html.erb -->
<%= render :partial => "form", :object => @user %>

<!-- app/views/user/_form.html.erb -->
<!-- Is this a new user to create, or an existing one to edit? -->
<% user = object %>
<% action_url = (user.persisted?) ? users_path : user_edit_path(user) %>

<form action="<%= action_url %>" method="post">
  <% if action == :edit %>
    <input type="hidden" name="_method" value="put">
  <% end %>
  <!-- inputs go here... -->
</form>
```

### Rendering objects

It is typical to have to render model objects often. There is a
shorthand for this:

```html+erb
<% @cats.each do |cat| %>
  <%= render cat %>
<% end %>
```

Rails will look at the `cat` value, see it is a `Cat` model object,
and will look for a `_cat.html.erb` partial template to use. It will
then render the template, setting `object`. Rails will also set a
variable named `cat` **inside** the partial, so that you can use a
more semantically meaningful name within:

```html+erb
<!-- app/views/shared/_cat.html.erb -->
<ul>
  <li>Name: <%= object.name %></li>
  <!-- more English-like to use `cat` -->
  <li>Age: <%= cat.age %></li>
</ul>
```

How do you think it knows to set the `cat` variable? The same way it
decides the partial to render: it looks at the class name of the model
object, and uses that.

### Rendering Collections

As seen above, partials are very useful in rendering collections. Just
like there is a shortcut to render a model object, you can also easily
render an array of model objects:

```html+erb
<%= render @cats %>
```

Rails will render the `_cat.html.erb` partial once for each item,
setting the `cat` local variable as before.
