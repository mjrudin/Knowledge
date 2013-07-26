# AJAX Remote Forms

Okay, cool kid, so you know how to use AJAX. Color me impressed.

Let's up our game. Let's write a form that, when the user clicks the
"submit" button will submit the form data in the background.

The key is the jQuery [`serialize` method][jquery-serialize-doc]. If
you have a form element (wrapped in jQuery, of course), you can call
the `serialize` method, which will extract the values from the `input`
tags contained in the `form`, and then serialize these to URL
encoding. As you know, URL encoding is the format that form data is
uploaded in.

Let's see it go!

```html
<!-- notice how I don't set the action/method on the form tag -->
<form id="cat-form">
  <input type="text" name="cat[name]">
  <input type="text" name="cat[color]">
  
  <input type="submit">
</form>

<script>
  $("#cat-form").find('input[type="submit"]').on(
    "click",
    function (event) {
      // Lookup `preventDefault`; it stops the browser's default action,
      // which is to make a synchronous submission of the form.
      // http://api.jquery.com/category/events/event-object
      event.preventDefault();

      // Check out the `on` documentation: `this` gets set to the
      // clicked button. Also check out the `HTMLFormElement` docs; check
      // out the `form` attribute.
      // * http://api.jquery.com/on
      // * https://developer.mozilla.org/en-US/docs/Web/API/HTMLFormElement
      var formData = $(this.form).serialize();

      // If `{ "cat[name]": "Gizmo", "cat[color]": "Black" }`, then
      // `formData == "cat%5Bname%5D=Gizmo&cat%5Bcolor%5D=Black"`.

      $.ajax({
        url: "/cats",
        type: "POST",
        data: formData,
        success: function () {
          console.log("Your callback here!");
        }
      });
    }
  );
</script>
```

[jquery-serialize-doc]: http://api.jquery.com/serialize

### Getting input values in JS `Object` format

It's great to get a URL encoded representation of the input values,
but it's also a little frustrating. URL encoding is difficult for us
to manipulate; just about the only thing we can do with it is submit
it to the server.

One pastability is to use a little-known jQuery plug-in called
[serializeJSON][serializeJSON]. I can't totally vouch for this plugin
(only ten followers), but it sounds like it does exactly what we want:
create a JavaScript object following the Rails parameter conventions.

[serializeJSON]: https://github.com/marioizquierdo/jquery.serializeJSON

Another possibility is to use jQuery's `serializeArray` method. This
differs from `serialize` in that it returns an array of name/value
pairs. But this isn't really the JS Object you wanted; you'd still
have to set all the values yourself. Plus, it won't handle arrays
(`user[friend_ids][]`) or nesting (`user[home][street_address]`).

Finally, you can just do it all yourself; set ids on each of the
inputs, pull out the values, and manually set them on a JS Object in
the submit callback. That's what I did when I first started learning.

## Authenticity token

**TODO**: doesn't `rails.js` add a prefilter for all AJAX requests
automatically?

What about the authenticity token? We could modify our form like so:

```html
<form id="cat-form">
  <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">

  <input type="text" name="cat[name]">
  <input type="text" name="cat[color]">
  
  <input type="submit">
</form>
```

Sometimes we need to access the form token from JavaScript. Here's a
common solution. Edit `app/layouts/application.html.erb`; this is the
default layout in which every Rails page is rendered. Toss in a line
of JavaScript:

```html
<script type="application/javascript">
  window._authenticity_token = '<%= form_authenticity_token %>';
</script>
```

Now you can use `_authenticity_token` anywhere in your JavaScript code
to gain access to the token. Here's a common use case:

```html
<script type="text/template" id="silly_template">
  <form>
    <input
      type="hidden"
      name="authenticity_token"
      value="<% _authenticity_token %>"
    >

    <input type="text" name="cat[name]">
    <input type="text" name="cat[color]">

    <input type="submit">
  </form>
</script>
```

Here we use an underscore template (you'll learn about this in a few
minutes). Underscore templates are templates of HTML code meant to be
rendered client-side by JavaScript. This template will now be able to
access the token.
