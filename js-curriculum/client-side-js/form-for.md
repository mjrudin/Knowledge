# `form_for` and `button_to`

## `form_for`

### Basics

We've been writing all our forms by hand for a while now. Because
writing forms is a big part of web development, Rails supplies helper
methods to help you with this. You should probably peruse the relevant
[Rails Guide][forms-guide].

I want you to use Rails form helpers very sparingly: I don't want you
to forget how to write a form yourself! Writing complicated forms
requires an understanding of how they work, so you should **not** rely
on form helpers as a crutch.

I do use [`form_for`][form-helper-doc], the Rails form building
work-hourse, a lot. Let's see a simple example first:

```html+erb
<%= form_for(@widget) do %>
  <label for="widget_name">Widget</label>
  <input type="text" name="widget[name]" id="widget_name">
  <br>
  
  <input type="submit">
<% end %>
```

This is exactly like a standard form, except that we've replaced the
wrapping `<form action="...` with the form helper. `form_for` takes
care of several things for us:

* It creates the wrapper `form` tag. Meh; I could do that.
* It sets up `action` and `method`
    * It looks at whether `@widget.persisted?` and chooses either
      `new_widget_url` or `widget_url(@widget)` to generate the `action`
      value.
    * It uses `persisted?` to choose whether to POST or PUT; it sets up
      the `_method` input.
    * Setting this involved a fair amount of annoying code: nice win :-)
* It sets up the `authenticity_token` input.
    * Nice not to have to worry about forgetting this.

### Generating inputs

We used `form_for` to build the wrapper `form` tag and reate the
`_method` and `authenticity_token` inputs. It can do more.

Optionally, the block you pass `form_for` can take an argument
(typically named `f`) that will be passed a *form builder*. In Rails
or Backbone, a form builder is an object that helps you build an HTML
form. Let's redo the above example:

```html+erb
<%= form_for(@widget) do |f| %>
  <!-- creates a label for `widget[name]` with the text "Widget Name" -->
  <%= f.label :name, "Widget Name" %>
  <%= f.text_field :name %>
  <br>
  
  <%= f.submit %>
<% end %>
```

Building inputs/labels this way acheives several things:

* It sets input `name` attributes according to conventions.
* It sets input/label `id`/`for` according toconventions.
* It will use `@widget.attribute_name`'s current value as the default
  for inputs.
    * This involved some fair amount of code.

### Don't forget!

Rails provides some relatively low-level form helpers; I like those
the best. The higher level ones (formtastic, simple\_form) get in my
way more. It's way more important to have facility with HTML forms
than with a high-level, abstract library formtastic or
simple\_form. So don't forget your training, don't neglect the original!

[forms-guides]: http://guides.rubyonrails.org/form_helpers.html
[form-helper-doc]: http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html

## `button_to`

`form_for` is great when you have a model object that you want to
create or udpate. In those cases, you need to fill out a variety of
inputs.

Other times, you only need a single button. For instance, a button to
destroy an object. Or to mark an item as favorited/unfavorited.

In that case, use `button_to`. Use it like so:

```html+erb
<!-- button to destroy a widget -->
<%= button_to "Destroy Widget", widget_url(@widget), :method => :delete %>

<!-- button to like a post; `:method => :post` is implicit -->
<%= button_to "Like Post", post_like_url(@post) %>
```

`button_to` generates a [`button`][button-mdn] HTML element. A button
is like an `<input type="submit">` tag, except it doesn't have an
associated form.

[button-mdn]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button
