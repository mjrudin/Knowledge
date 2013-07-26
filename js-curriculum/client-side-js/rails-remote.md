# `:remote => true`

We've seen how to use AJAX to make asynchronous HTTP requests in the
background. There is nothing particularly difficult to this, but it
can be a little tedious to write the code for making the AJAX
request, and for installing a click handler on submit.

Oftentimes we just want to modify an existing form or button to submit
an AJAX request instead of a synchronous request. We then want to
specify a callback to handle the server's response to the request.

If we use `form_for` and `button_to`, Rails will help us. All we need
to do is pass the option `:remote => true` (e.g., `form_for(@widget,
:remote => true)`). Specifying this option instructs Rails to generate
the JavaScript code to:

0. Override the default action (e.g., a form is not submitted
   synchronously).
0. Instead, `rails.js` (the client-side portion of Rails that
   implements `:remote => true`) will make an AJAX request.
0. When the AJAX call completes, `rails.js` will *fire an event* that
   will let you execute a callback.

## Using `:remote => true`

To change a form from making a synchronous request to using AJAX, just
slap on a `:remote => true` option.

```html+erb
<%= form_for(
      @widget,
      :remote => true,
      # we'll use the form class in a later example
      :html => { :class => "widget_form` }) do |f| %>
  <!- ... -->
<% end %>
```

That's it. Now the form is POSTed using AJAX.

## Handling the response

Great, the request is made by AJAX, but how do we handle the response?
Perhaps we want to congratulate the user after the form is
successfully processed. Or maybe we want to display validation errors
if any are returned.

Specifying `:remote => true` only means that the request is made via
AJAX; it doesn't specify any JavaScript to run when the request
completes.

The AJAX request kicked off through `:remote => true` will trigger a
*custom event* on the form DOM element when it completes. You have
seen events before: when you say `$el.on("click", clickCallbackFn)`,
you are listening for a `click` event on the `$el` DOM element.

You can trigger your own custom events on DOM elements like so:
`$el.trigger("myCustomEvent")`. If anyone has installed a handler for
this event (`$el.on("myCustomEvent", callbackFn)`), there callback
will be triggered.

So let's install a handler to be called when the AJAX success event is
fired by `rails.js`:

```javascript
// install a handler to respond to successful form submission
$(".widget_form").on("ajax:success", function (event, data) {
  // do something with the response
  console.log(data);
  
  // remove the form and add a success message
  var successBox = $("<p></p>");
  successBox.text("Good work submitting that form!");

  // when jQuery calls an event handler, `this` is bound to the
  // element the event was fired on. So `this` is the form, which is
  // replaced.
  this.replaceWith(successBox);
});
```

The name of the custom event that Rails fires is
`ajax:success`. Failure of the AJAX request results in `ajax:error`
being fired.

### `button_to`

```html+erb
<!-- rails will put the button inside an empty `form` tag (the form
     will have the `authenticity_token`, `_method` inputs) -->
<%= button_to(
      "Destroy post",
      post_url(@post),
      :method => :delete,
      :form => { :class => "destroy_post_form" }) %>

<script>
  // again, the event is fired on the form tag, so install the handler
  // on the form tag and not the button tag.
  $(".destroy_post_form").on("ajax:success", function (event, data) {
    // whatevs
  });
</script>
```

## References

* http://api.jquery.com/serialize/
